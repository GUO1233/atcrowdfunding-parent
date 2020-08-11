package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.StringUtil;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    TRoleMapper tRoleMapper;

    @Override
    public PageInfo<TRole> getPageInfo(String condition) {
        TRoleExample tRoleExample = new TRoleExample();
        if(StringUtil.isNotEmpty(condition)){
            tRoleExample.createCriteria().andNameLike("%"+condition+"%");
        }

        List<TRole> tRoles = tRoleMapper.selectByExample(tRoleExample);
        PageInfo<TRole> pageInfo = new PageInfo<>(tRoles, 5);
        return pageInfo;
    }

    @Override
    public void saveRole(TRole role) {
        tRoleMapper.insert(role);
    }

    @Override
    public TRole getRoleById(Integer id) {
        TRole tRole = tRoleMapper.selectByPrimaryKey(id);
        return tRole;
    }

    @Override
    public void updateRole(TRole role) {
        tRoleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteRole(Integer id) {
        tRoleMapper.deleteByPrimaryKey(id);
    }
}
