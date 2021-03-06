

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create WorkBook</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">WorkBook List</g:link></span>
        </div>
        <div class="body">
            <h1>Create WorkBook</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${workBookInstance}">
            <div class="errors">
                <g:renderErrors bean="${workBookInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="book">Book:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:workBookInstance,field:'book','errors')}">
                                    <g:select optionKey="id" from="${Book.list()}" name="book.id" value="${workBookInstance?.book?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="student">Student:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:workBookInstance,field:'student','errors')}">
                                    <g:select optionKey="id" from="${Student.list()}" name="student.id" value="${workBookInstance?.student?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
