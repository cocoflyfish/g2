package com.g2.web.controller.mgr.game;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.apache.shiro.SecurityUtils;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springside.modules.web.Servlets;

import com.g2.entity.Log;
import com.g2.entity.User;
import com.g2.entity.game.ConfigServer;
import com.g2.entity.game.FunctionEmail;
import com.g2.service.account.AccountService;
import com.g2.service.account.ShiroDbRealm.ShiroUser;
import com.g2.service.game.FunctionEmailService;
import com.g2.service.log.LogService;
import com.g2.service.server.ServerService;
import com.g2.util.JsonBinder;
import com.g2.util.SpringHttpClient;
import com.g2.web.controller.mgr.BaseController;
import com.google.common.collect.Maps;

@Controller("functionEmailController")
@RequestMapping(value="/manage/game/functionEmail")
public class FunctionEmailController extends BaseController{

	private static final String PAGE_SIZE = "50";
	
	private static final Logger logger = LoggerFactory.getLogger(FunctionEmailController.class);
	
	private static Map<String,String> sortTypes = Maps.newLinkedHashMap();
	
	static{
		sortTypes.put("auto","自动");
		sortTypes.put("id", "Id");
	}
	
	public static Map<String, String> getSortTypes() {
		return sortTypes;
	}
	
	public static void setSortTypes(Map<String, String> sortTypes) {
		FunctionEmailController.sortTypes = sortTypes;
	}
	
	@Autowired
	private FunctionEmailService functionEmailService;
	
	@Autowired
	private AccountService accountService;

	@Autowired
	private LogService logService;
	
	@Value("#{envProps.server_url}")
	private String excelUrl;
	
	private static JsonBinder binder = JsonBinder.buildNonDefaultBinder();
	
	/**
	 * 新增页面
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@RequestMapping(value = "/add" ,method=RequestMethod.GET)
	public String add(Model model) throws JsonParseException, JsonMappingException, IOException{
		ShiroUser user = getCurrentUser();
		User u = accountService.getUser(user.id);
		List<ConfigServer> beanList = binder.getMapper().readValue(new SpringHttpClient().getMethodStr(excelUrl), new TypeReference<List<ConfigServer>>() {}); 
		model.addAttribute("servers", beanList);
		return "/game/functionemail/add";
	}
	
	/**
	 * 新增
	 */
	@RequestMapping(value = "/save",method=RequestMethod.POST)
	public String save(FunctionEmail functionEmail,ServletRequest request,RedirectAttributes redirectAttributes,Model model){
		//提交邮件 
		logService.log(getCurrentUser().getName(), getCurrentUser().getName() + "：新增邮件", Log.TYPE_FUNCTION_EMAIL);
		redirectAttributes.addFlashAttribute("message", "邮件提交成功");
		return "redirect:/manage/game/functionEmail/add";
	}
	
	@RequestMapping(value = "/findUserName")
	@ResponseBody
	public String findUserName(@RequestParam("userId") String userId) {
		//查询 mongodb 找到 userId 对应的 userName
		return "战胜无双2";
	}
	
	/**
	 * 取出Shiro中的当前用户Id.
	 */
	public Long getCurrentUserId() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user.id;
	}
	
	public ShiroUser getCurrentUser() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user;
	}
}
