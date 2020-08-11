package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.dao.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MeauService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class MeauServiceImpl implements MeauService {
    @Autowired
    TMenuMapper tMenuMapper;
    @Override
    public List<TMenu> queryTMenus() {
        List<TMenu> tMenus = tMenuMapper.selectByExample(null);
        List<TMenu> parentMenuList = new ArrayList<>();
        HashMap<Integer, TMenu> map = new HashMap<>();
        for (TMenu tMenu : tMenus) {
            Integer pid = tMenu.getPid();
            if(pid==0){
                parentMenuList.add(tMenu);
                map.put(tMenu.getId(),tMenu);
            }
        }
        //迭代，组合父子关系
        for (TMenu tMenu : tMenus) {
            Integer pid = tMenu.getPid();
            map.get(pid);
            if(map.get(pid)!=null){
                map.get(pid).getChildren().add(tMenu);//根据子菜单的pid也就是主菜单的id获取相应的主菜单，然后添加子菜单
            }
        }
        System.out.println("parentMenuList = " + parentMenuList);
        return parentMenuList;
    }

    @Override
    public List<TMenu> listAllMeanusTree() {
        List<TMenu> tMenus = tMenuMapper.selectByExample(null);
        return tMenus;
    }

    @Override
    public void saveMenu(TMenu menu) {
        tMenuMapper.insertSelective(menu);
    }

    @Override
    public void deleteMenu(Integer id) {
        tMenuMapper.deleteByPrimaryKey(id);
    }

    @Override
    public TMenu doUpdateGetMenu(Integer id) {
        TMenu tMenu = tMenuMapper.selectByPrimaryKey(id);
        return tMenu;
    }

    @Override
    public void updateMenu(TMenu menu) {
        tMenuMapper.updateByPrimaryKeySelective(menu);
        //tMenuMapper.updateByExampleSelective(menu);

    }
}
