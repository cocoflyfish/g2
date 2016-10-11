package com.g2.web.api.v1.placard;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.g2.entity.game.FunctionPlacard;
import com.g2.service.game.FunctionPlacardService;
import com.g2.web.api.BaseApiController;

@Controller
@RequestMapping(value = "/api/v1/placard")
public class PlacardApiController extends BaseApiController{
	
	@Autowired
	private FunctionPlacardService functionPlacardService;
	
	@InitBinder
	protected void initBinder(ServletRequestDataBinder binder){
		binder.registerCustomEditor(Date.class,"crDate",new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));
		binder.registerCustomEditor(Date.class,"upDate",new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));
	}
	
	@RequestMapping(value ="/list",method = RequestMethod.GET ,  produces = "application/json;charset=UTF-8")
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	public List<FunctionPlacard> list(@RequestParam(value = "pageNum",defaultValue="1", required = false) Integer pageNum,
			@RequestParam(value = "pageSize",defaultValue="10", required = false) Integer pageSize) throws Exception{
		List<FunctionPlacard> functionPlacards = functionPlacardService.findAll();
		return functionPlacards;
	}
	
}
