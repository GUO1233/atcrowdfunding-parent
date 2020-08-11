package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.execption.LoginException;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.github.pagehelper.PageInfo;

import java.util.HashMap;

public interface AdminService {

    TAdmin getAdminByLogin(String loginacct, String userpswd) throws LoginException;

    PageInfo<TAdmin> listPage(HashMap<String, Object> paramMap);

    void saveAdmin(TAdmin admin);

    TAdmin getAdminById(Integer id);

    void updateAdmin(TAdmin admin);

    void deleteAdmin(Integer id);

    void deleteBatch(String ids);
}
