/*************************************************************************
    free code from dyn-web.com
*************************************************************************/

// var req = dw_XHR.makeRequest( url, callback, [method, postData] )

var dw_XHR = {
    
    makeRequest: function( url, callback, method, postData ) {
        var req = this.createRequestObject();
        if (!req) { return null; }
        method = method || 'GET';
        req.open( method, url, true );
        
        if ( method.toUpperCase() == 'POST' ) {
            req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        
        req.onreadystatechange = function() {
            if (req.readyState == 4) {
                dw_XHR.handleResponse(req, callback);
            }
        }
        req.send(postData);
        return req;   
    },
    
    createRequestObject: function() {
        var req;
        if (window.XMLHttpRequest) {
            try {
                req = new XMLHttpRequest();
            } catch(e) {}
        } else if (window.ActiveXObject) {
            try {
                req = new ActiveXObject("Msxml2.XMLHTTP");
            } catch(e) {
                try {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                } catch(e) {}
            }
        }
        return req;
    },
    
    handleResponse: function (req, callback) {
        var status;
        try { // avoid Firefox errors
            status = req.status;
        } catch (e) {
            return;
        }
        
        if ( status == 200 ) {
            if ( callback && callback.success ) {
                callback.success(req);
            }
        } else {
            if ( callback && callback.failure ) {
                callback.failure(req);
            }
        }
        req.onreadystatechange = function(){};
        req = null;
    },
    
    encodeVars: function (oParams) {
        var str = '';
        for (var i in oParams ) {
            str += encodeURIComponent(i) + '=' + encodeURIComponent( oParams[i] ) + '&';
        }
        return str.slice(0, -1);
    }    
    
}
