<%--
  Created by IntelliJ IDEA.
  User: 28331
  Date: 2020/7/27
  Time: 17:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="col-sm-3 col-md-2 sidebar">
    <div class="tree">
        <ul style="padding-left:0px;" class="list-group">
            <c:forEach items="${listParentMenus}" var="parentMenus">
               <c:if test="${empty parentMenus.children}">
                   <li class="list-group-item tree-closed" >
                       <a href="${PATH}/${parentMenus.url}"><i class="${parentMenus.icon}"></i> ${parentMenus.name}</a>
                   </li>
               </c:if>
                <c:if test="${not empty parentMenus.children}">
                    <li class="list-group-item tree-closed">
                        <span><i class="${parentMenus.icon}"></i> ${parentMenus.name} <span class="badge" style="float:right">${parentMenus.children.size()}</span></span>
                        <ul style="margin-top:10px;display:none;">
                            <c:forEach items="${parentMenus.children}" var="childMenus">
                                <li style="height:30px;">
                                    <a href="${PATH}/${childMenus.url}"><i class=" ${childMenus.icon}"></i> ${childMenus.name}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>
            </c:forEach>

        </ul>
    </div>
</div>
