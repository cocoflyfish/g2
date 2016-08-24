<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix="huake" uri="/huake"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

	<script type="text/javascript">
		// G2 对数据源格式的要求，仅仅是 JSON 数组，数组的每个元素是一个标准 JSON 对象。
		// Step 1: 创建 Chart 对象
		var chart_a1 = [
		                {item: "创新", value: 3.9, level: 3},
		                {item: "商业成熟度", value: 4.4, level: 3},
		                {item: "创新与成熟因素", value: 4.1, level: 3},
		                {item: "市场大小", value: 6.9, level: 2},
		                {item: "技术准备", value: 3.5, level: 2},
		                {item: "金融市场发展", value: 4.3, level: 2},
		                {item: "劳动市场效率", value: 4.6, level: 2},
		                {item: "商品市场效率", value: 4.4, level: 2},
		                {item: "高等教育和训练", value: 4.4, level: 2},
		                {item: "效率增强器", value: 4.7, level: 2},
		                {item: "健康和基础教育", value: 6.1, level: 1},
		                {item: "宏观经济环境", value: 6.4, level: 1},
		                {item: "设施", value:4.7, level: 1},
		                {item: "机构", value: 4.2, level: 1},
		                {item: "基本要求", value: 5.3, level: 1}
		              ];
		var chart_b1 = [
		                {'time': '10:10', 'call': 4, 'waiting': 2, 'people': 2},
		                {'time': '10:15', 'call': 2, 'waiting': 6, 'people': 3},
		                {'time': '10:20', 'call': 13, 'waiting': 2, 'people': 5},
		                {'time': '10:25', 'call': 9, 'waiting': 9, 'people': 1},
		                {'time': '10:30', 'call': 5, 'waiting': 2, 'people': 3},
		                {'time': '10:35', 'call': 8, 'waiting': 2, 'people': 1},
		                {'time': '10:40', 'call': 13, 'waiting': 1, 'people': 2},
		                {'time': '10:45', 'call': 5, 'waiting': 2, 'people': 3},
		                {'time': '10:50', 'call': 2, 'waiting': 3, 'people': 1},
		                {'time': '10:55', 'call': 7, 'waiting': 9, 'people': 8},
		                {'time': '11:00', 'call': 17, 'waiting': 9, 'people': 3},
		                {'time': '11:05', 'call': 8, 'waiting': 2, 'people': 3},
		                {'time': '11:20', 'call': 6, 'waiting': 5, 'people': 2},
		                {'time': '11:25', 'call': 7, 'waiting': 4, 'people': 7}
		              ];
		var chart_d1 = [{"province":'北京市1', "population":19612368},{"province":"内蒙古自治区1", "population":24706291},{"province":"黑龙江省1", "population":38313991},
		                        {"province":'北京市', "population":19612368},{"province":"内蒙古自治区", "population":24706291},{"province":"黑龙江省", "population":38313991},
		                        {"province":"广西壮族自治区", "population":46023761},{"province":"海南省", "population":8671485},{"province":"西藏自治区", "population":3002165},{"province":"陕西省", "population":37327379}];
		var chart_c1 = [{"province":'北京市1', "population":88888888},{"province":"内蒙古自治区1", "population":24706291},{"province":"黑龙江省1", "population":38313991},
		                        {"province":'北京市', "population":19612368},{"province":"内蒙古自治区", "population":24706291},{"province":"黑龙江省", "population":38313991},
		                        {"province":"广西壮族自治区", "population":46023761},{"province":"海南省", "population":8671485},{"province":"西藏自治区", "population":3002165},{"province":"陕西省", "population":37327379}];
		
		//---------------------- chart_a1 ----------------

		var chart = new G2.Chart({
			id : 'chart_a1',
			width : 1000,
			height : 500
		});
		chart.source(chart_a1, {
			'value' : {
				min : 0,
				max : 10,
				tickCount : 10
			}
		});
		chart.coord('polar', {
			radius : 0.8
		});
		chart.axis('value', { // 设置坐标系栅格样式
			grid : {
				type : 'polygon' //圆形栅格，可以改成
			}
		});
		chart.axis('item', { // 设置坐标系栅格样式
			line : null
		});
		chart.line().position('item*value').color('#F15A24').label('value');
		chart.point().position('item*value').color('level',
				[ '#FCDC21', '#FF931E', '#ED1C24' ]).shape('circle');
		chart.render();
		//---------------------- chart_a1 ----------------
		
		//---------------------- chart_b1 ----------------

		var Frame = G2.Frame;
		var frame = new Frame(chart_b1);
		frame = Frame.combinColumns(frame, [ 'call', 'waiting' ], 'count',
				'type', [ 'time', 'people' ]);
		var chart = new G2.Chart({
			id : 'chart_b1',
			width : 1000,
			height : 500
		});
		chart.source(frame, {
			'count' : {
				alias : '话务量（通）',
				min : 0
			},
			'people' : {
				alias : '人数（人）',
				min : 0
			}
		});
		// 去除 X 轴标题
		chart.axis('time', {
			title : null
		});
		chart.legend(false);// 不显示图例
		chart.intervalStack().position('time*count').color('type',
				[ '#348cd1', '#43b5d8' ]); // 绘制层叠柱状图
		chart.line().position('time*people').color('#5ed470').size(2).shape(
				'smooth'); // 绘制曲线图
		chart.point().position('time*people').color('#5ed470'); // 绘制点图
		chart.render();
		//---------------------- chart_b1 ----------------

		//---------------------- chart_c1 ----------------
		var Stat = G2.Stat;
		var Frame = G2.Frame;
		var frame = new Frame(chart_c1);
		frame = Frame.sort(frame, 'population'); // 将数据按照population 进行排序，由大到小
		var chart = new G2.Chart({
			id : 'chart_c1',
			width : 1000,
			height : 500,
			plotCfg : {
				margin : [ 20, 120, 80 ]
			}
		});
		chart.source(frame);
		chart.axis('province', {
			title : null
		});
		chart.coord('rect').transpose();
		chart.interval().position('province*population').color('province');
		// 使用 chart.guide() 展示文本
		frame.each(function(obj, index) {
			chart.guide().text([ index + 0.3, 1000000 ],
					'人数：' + obj.population, {
						'text-anchor' : 'start'
					});
		});
		chart.render();
		//---------------------- chart_c1 ----------------

		//---------------------- chart_d1 ----------------
		var Stat = G2.Stat;
		var Frame = G2.Frame;
		var frame = new Frame(chart_d1);
		frame = Frame.sort(frame, 'population'); // 将数据按照population 进行排序，由大到小
		var chart = new G2.Chart({
			id : 'chart_d1',
			width : 1000,
			height : 500,
			plotCfg : {
				margin : [ 20, 120, 80 ]
			}
		});
		chart.source(frame);
		chart.axis('province', {
			title : null
		});
		chart.coord('rect').transpose();
		chart.interval().position('province*population').color('province');
		// 使用 chart.guide() 展示文本
		frame.each(function(obj, index) {
			chart.guide().text([ index + 0.3, 1000000 ],
					'人数：' + obj.population, {
						'text-anchor' : 'start'
					});
		});
		chart.render();
		//---------------------- chart_d1 ----------------
	</script>
