package com.g2.web.controller.mgr.game;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springside.modules.web.Servlets;

import com.g2.entity.Log;
import com.g2.entity.Server;
import com.g2.entity.User;
import com.g2.entity.game.FunctionPlacard;
import com.g2.entity.game.MonitorServer;
import com.g2.service.account.AccountService;
import com.g2.service.game.MonitorServerService;
import com.g2.service.log.LogService;
import com.g2.service.server.ServerService;
import com.g2.util.HttpClientUts;
import com.g2.util.JsonBinder;
import com.g2.util.MySortList;
import com.g2.util.SpringHttpClient;
import com.g2.web.controller.mgr.BaseController;
import com.google.common.collect.Maps;

/**
 * 服务器状态管理的controller
 *
 */
@Controller("monitorServerController")
@RequestMapping(value="/manage/game/monitorServer")
public class MonitorServerController extends BaseController{

	private static final Logger logger = LoggerFactory.getLogger(MonitorServerController.class);
	
	private static final String PAGE_SIZE = "15";
	
	SimpleDateFormat sdf =   new SimpleDateFormat("yyyy-MM-dd" ); 
	Calendar calendar = new GregorianCalendar(); 

	private static Map<String, String> sortTypes = Maps.newLinkedHashMap();

	static {
		sortTypes.put("auto", "自动");
		sortTypes.put("totalUser", "总玩家人数");
		sortTypes.put("onlineUser", "在线人数");
	}
	
	public static Map<String, String> getSortTypes() {
		return sortTypes;
	}

	public static void setSortTypes(Map<String, String> sortTypes) {
		MonitorServerController.sortTypes = sortTypes;
	}

	@Override
	@InitBinder
	protected void initBinder(ServletRequestDataBinder binder){
		binder.registerCustomEditor(Date.class,"createDate",new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));
		binder.registerCustomEditor(Date.class,"upDate",new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));
	}
	
	@Autowired
	private AccountService accountService;
	
	@Autowired
	private MonitorServerService monitorServerService;
	
	@Autowired
	private LogService logService;
	
	@Value("#{envProps.server_url}")
	private String excelUrl;
	
	private static JsonBinder binder = JsonBinder.buildNonDefaultBinder();
	
	/**
	 * @throws Exception 
	 */
	@RequestMapping(value = "index", method = RequestMethod.GET)
	public String index(@RequestParam(value = "page", defaultValue = "1") int pageNumber,
			@RequestParam(value = "page.size", defaultValue = PAGE_SIZE) int pageSize,
			@RequestParam(value = "sortType", defaultValue = "auto")String sortType, Model model,
			ServletRequest request) throws Exception{
		logger.debug("服务器状态");
		Map<String, Object> searchParams = Servlets.getParametersStartingWith(request, "search_");
		Long userId = monitorServerService.getCurrentUserId();
		User user = accountService.getUser(userId);

		List<MonitorServer> monitorServers = new ArrayList<>();
		for (int i = 1; i <= 10; i++) {
			MonitorServer f = new MonitorServer();
			f.setId(Long.valueOf(i));
			f.setServerId(String.valueOf(i));
			f.setServerName("安卓"+i+"区");
			if(i>5){
				f.setLoad("1");
			}else{
				f.setLoad("0");
			}
			f.setOnlineUser(String.valueOf(10*i));
			f.setTotalUser(String.valueOf(100*i));
			f.setIp("127.0.0.1");
			monitorServers.add(f);
		}
		
		if(null!= request.getParameter("search_EQ_load")){
			List<MonitorServer> save = new ArrayList<MonitorServer>();  
			for (MonitorServer monitorServer : monitorServers) {
				if(!request.getParameter("search_EQ_load").equals(monitorServer.getLoad())){
					save.add(monitorServer);
				}
			}
			monitorServers.removeAll(save);  
		}
		
		/* 对 list monitorServers 排序 */
		MySortList<MonitorServer> msList = new MySortList<MonitorServer>();
		if ("auto".equals(sortType)) {
			msList.sortByMethod(monitorServers, "getId", false);
		} else if ("onlineUser".equals(sortType)) {
			msList.sortByMethod(monitorServers, "getOnlineUser", true);
		} if ("totalUser".equals(sortType)) {
			msList.sortByMethod(monitorServers, "getTotalUser", true);
		} 
		/* 对 list monitorServers 排序 */
		
		PageImpl<MonitorServer> ps = new PageImpl<MonitorServer>(monitorServers, null, monitorServers.size());
		
		model.addAttribute("sortType", sortType);
		model.addAttribute("sortTypes", sortTypes);
		model.addAttribute("user", user);
		model.addAttribute("monitorServers", ps);
		
		logService.log(user.getName(), user.getName() + "：访问服务器状态页面", Log.TYPE_MONITOR_SERVER);
		// 将搜索条件编码成字符串，用于排序，分页的URL
		model.addAttribute("searchParams", Servlets.encodeParameterStringWithPrefix(searchParams, "search_"));
		return "/game/monitorserver/index";
	}
	
	/**
	 * 服务器获取时间
	 */
	@RequestMapping(value="/getDate")
	@ResponseBody
	public Map<String, String> getDate(){
		Map<String,String> dateMap = new HashMap<String, String>();
		SimpleDateFormat sdf =   new SimpleDateFormat("yyyy-MM-dd" ); 
		Calendar calendar = new GregorianCalendar(); 
		String nowDate = sdf.format(new Date());
		
	    calendar.setTime(new Date()); 
	    calendar.add(Calendar.DATE,-1);
	    String yesterday = sdf.format(calendar.getTime());
	    
	    calendar.setTime(new Date()); 
	    calendar.add(Calendar.DATE,-7);
	    String sevenDayAgo = sdf.format(calendar.getTime()); 
	    
	    calendar.setTime(new Date()); 
	    calendar.add(Calendar.DATE,-30);
	    String thirtyDayAgo = sdf.format(calendar.getTime()); 
		
	    dateMap.put("nowDate",nowDate);
	    dateMap.put("yesterday",yesterday);
	    dateMap.put("sevenDayAgo",sevenDayAgo);
	    dateMap.put("thirtyDayAgo",thirtyDayAgo);
		return dateMap;
	}
	
}
