package com.g2.service.store;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springside.modules.persistence.DynamicSpecifications;
import org.springside.modules.persistence.SearchFilter;
import org.springside.modules.persistence.SearchFilter.Operator;

import com.g2.entity.Stores;
import com.g2.entity.User;
import com.g2.repository.StoreDao;
import com.g2.repository.UserDao;
import com.g2.service.account.AccountService;

@Component
@Transactional
/**
 * @Description 门店Service
 * @author Administrator
 *
 */
public class StoreService {

	@Autowired
	private StoreDao storeDao;

	@Autowired
	private AccountService accountService;

	@Autowired
	private UserDao userDao;

	/**
	 * 通过ID查询
	 * 
	 * @param id
	 * @return
	 */
	public Stores findById(long id) {
		return storeDao.findOne(id);
	}
	
	public Stores findByName(String name){
		return storeDao.findByName(name);
	}
	
	public void delById(Long StoreId){
		storeDao.delete(StoreId);
	}

	/**
	 * 分页查询
	 * 
	 * @param userId
	 * @param searchParams
	 * @param pageNumber
	 * @param pageSize
	 * @param sortType
	 * @return
	 */
	public Page<Stores> findStoresByCondition(Long userId,
			Map<String, Object> searchParams, int pageNumber, int pageSize,
			String sortType) {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize,
				sortType);
		Specification<Stores> spec = buildSpecification(userId, searchParams);
		return storeDao.findAll(spec, pageRequest);
	}

	/**
	 * api分页
	 * 
	 * @param searchParams
	 * @param pageNumber
	 * @param pageSize
	 * @param sortType
	 * @return
	 */
	public Page<Stores> findByApiCondition(Map<String, Object> searchParams,
			int pageNumber, int pageSize, String sortType) {
		PageRequest pageRequest = buildPageRequest(pageNumber, pageSize,
				sortType);
		Specification<Stores> spec = buildApiSpecification(null, searchParams);
		return storeDao.findAll(spec, pageRequest);
	}

	/**
	 * 新增
	 * 
	 * @param store
	 */
	public void save(Stores store) {
		store.setStatus(Stores.STATUS_VALIDE);
		storeDao.save(store);
	}

	/**
	 * 删除
	 * 
	 * @param store
	 */
	public void del(Stores store) {
		Stores store1 = this.findById(Long.valueOf(store.getId()));
		store1.setStatus(Stores.STATUS_INVALIDE);
		Set<User> users = store1.getUsers();
		for (User user : users) {
			user.setStatus(User.STATUS_INVALIDE);
			userDao.save(user);
		}
		storeDao.save(store1);
	}

	/**
	 * 修改
	 * 
	 * @param store
	 */
	public void update(Stores store) {
		Stores store1 = storeDao.findOne(store.getId());
		store1.setName(store.getName());
		storeDao.save(store1);
	}

	/**
	 * 查询全部（有效）
	 * 
	 * @return
	 */
	public List<Stores> findList() {
		return storeDao.findList();
	}

	/**
	 * 通过用户的ID进行查询，用户角色相关，门店状态过虑
	 * 
	 * @param id
	 * @return
	 */
	public List<Stores> findListByUid(Long id) {
		Map<String, SearchFilter> filters = new HashMap<String, SearchFilter>();

		User user = accountService.getUser(id);
		if (!user.getRoles().equals(User.USER_ROLE_ADMIN)
				&& !user.getRoles().equals(User.USER_ROLE_BUSINESS)) {
			filters.put("id",
					new SearchFilter("id", Operator.EQ, user.getStoreId()));
		}
		filters.put("status", new SearchFilter("status", Operator.EQ,
				Stores.STATUS_VALIDE));
		Specification<Stores> spec = DynamicSpecifications.bySearchFilter(
				filters.values(), Stores.class);
		return storeDao.findAll(spec);
	}

	/**
	 * 用户自提货，返回一个唯一的用户选择提货的门店
	 * 
	 * @param id
	 * @return pengqiuyuan
	 */
	public Stores findOneByUid(Long id) {
		Map<String, SearchFilter> filters = new HashMap<String, SearchFilter>();
		User user = accountService.getUser(id);
		filters.put("id",
				new SearchFilter("id", Operator.EQ, user.getStoreId()));
		filters.put("status", new SearchFilter("status", Operator.EQ,
				Stores.STATUS_VALIDE));
		Specification<Stores> spec = DynamicSpecifications.bySearchFilter(
				filters.values(), Stores.class);
		return storeDao.findOne(spec);
	}


	/**
	 * 创建分页请求.
	 */
	private PageRequest buildPageRequest(int pageNumber, int pagzSize,
			String sortType) {
		Sort sort = null;
		if ("auto".equals(sortType)) {
			sort = new Sort(Direction.DESC, "id");
		} else if ("createDate".equals(sortType)) {
			sort = new Sort(Direction.DESC, "createDate");
		}
		return new PageRequest(pageNumber - 1, pagzSize, sort);
	}

	/**
	 * 创建动态查询条件组合.
	 */
	private Specification<Stores> buildApiSpecification(Long userId,
			Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);

		filters.put("status", new SearchFilter("status", Operator.EQ,
				Stores.STATUS_VALIDE));

		Specification<Stores> spec = DynamicSpecifications.bySearchFilter(
				filters.values(), Stores.class);
		return spec;
	}

	/**
	 * 创建动态查询条件组合.
	 */
	private Specification<Stores> buildSpecification(Long userId,Map<String, Object> searchParams) {
		Map<String, SearchFilter> filters = SearchFilter.parse(searchParams);
		User user = accountService.getUser(userId);
		if (!user.getRoles().equals(User.USER_ROLE_ADMIN)) {
			filters.put("id",new SearchFilter("id", Operator.EQ, user.getStoreId()));
			filters.put("status", new SearchFilter("status", Operator.EQ,Stores.STATUS_VALIDE));
		}
		filters.put("status", new SearchFilter("status", Operator.EQ,Stores.STATUS_VALIDE));
		Specification<Stores> spec = DynamicSpecifications.bySearchFilter(filters.values(), Stores.class);
		return spec;
	}

}
