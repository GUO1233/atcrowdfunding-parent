package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.execption.LoginException;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.dao.TAdminMapper;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    TAdminMapper adminMapper;


    @Override
    public TAdmin getAdminByLogin(String loginacct, String userpswd) throws LoginException{
        TAdminExample tAdminExample = new TAdminExample();
        tAdminExample.createCriteria().andLoginacctEqualTo(loginacct);
        List<TAdmin> tAdmins = adminMapper.selectByExample(tAdminExample);
        if(tAdmins==null ||tAdmins.size()==0){
            throw new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }

        TAdmin admin=tAdmins.get(0);
        if(!admin.getUserpswd().equals(MD5Util.digest(userpswd))){
            throw new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }
        return admin;
    }

    @Override
    public PageInfo<TAdmin> listPage(HashMap<String, Object> paramMap) {
        TAdminExample tAdminExample = new TAdminExample();
        //请求参数
        String condition =(String) paramMap.get("condition");
        //判断请求参数是否存在，是否要根据请求参数进行where条件查询
        if(!StringUtils.isEmpty(condition)){
            TAdminExample.Criteria criteria = tAdminExample.createCriteria();
            criteria.andLoginacctLike("%"+condition+"%");
            TAdminExample.Criteria criteria1 = tAdminExample.createCriteria();
            criteria1.andUsernameLike("%"+condition+"%");
            TAdminExample.Criteria criteria2 = tAdminExample.createCriteria();
            criteria2.andEmailLike("%"+condition+"%");
            tAdminExample.or(criteria1);
            tAdminExample.or(criteria2);

        }

        //有查询条件根据条件查询，没有查询条件查询所有；根据查询结果进行分页。
        //limit ?,? 索引不是从0开始的，需要指定，开始索引，分页条数
        //limit ?  当索引是从0开始的，可以省略第一个参数
        List<TAdmin> adminList = adminMapper.selectByExample(tAdminExample);
        int navigatePages=5;//导航页的个数
        PageInfo<TAdmin> pageInfo = new PageInfo<>(adminList, navigatePages);
        return pageInfo;
    }

    @Override
    public void saveAdmin(TAdmin admin) {
        adminMapper.insertSelective(admin);
    }

    @Override
    public TAdmin getAdminById(Integer id) {
        TAdmin admin = adminMapper.selectByPrimaryKey(id);
        return admin;
    }

    @Override
    public void updateAdmin(TAdmin admin) {
        adminMapper.updateByPrimaryKeySelective(admin);

    }

    @Override
    public void deleteAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatch(String ids) {
        if (!StringUtils.isEmpty(ids)){
            List<Integer> list = new ArrayList<>();
            String[] idsArr = ids.split(",");
            for (String s : idsArr) {
                int id = Integer.parseInt(s);
                list.add(id);
            }
            TAdminExample tAdminExample = new TAdminExample();
            tAdminExample.createCriteria().andIdIn(list);
            adminMapper.deleteByExample(tAdminExample);
        }
    }

}
