package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TMenu;

import java.util.List;

public interface MeauService {
    public List<TMenu> queryTMenus();


    List<TMenu> listAllMeanusTree();

    void saveMenu(TMenu menu);

    void deleteMenu(Integer id);

    TMenu doUpdateGetMenu(Integer id);

    void updateMenu(TMenu menu);
}
