/*************************************************************************
    This code is from Dynamic Web Coding at dyn-web.com
    Copyright 2010 by Sharon Paine 
    See Terms of Use at www.dyn-web.com/business/terms.php
    regarding conditions under which you may use this code.
    This notice must be retained in the code as is!
*************************************************************************/

// for use with dw_tooltips.js to retrieve content via ajax

dw_Tooltip.initAjaxRequest = function (id) {
    dw_Tooltip.Ajax.init(id);
}

dw_Tooltip.Ajax = {
    request: null, reqTimer: 0, lastRequest: 0, // avoid repeated rapid requests
    // need longer delay for ie6 ? (can crash on old slow pc's)
    reqDelay: (window.ActiveXObject && !window.XMLHttpRequest)? 1000: 500,
    pendingReq: false, respRecd: false,
    
    init: function (id) {
        var obj = dw_Tooltip.content_vars[id];
        // to display in tooltip while waiting for response
        var msg = this.waitMsg? this.waitMsg: 'Retrieving info ...';
        obj['content'] = msg;
        var queryStr = obj.params? dw_XHR.encodeVars(obj.params): '';
        this.pendingReq = true;
        
        var ts = new Date().getTime(); var dif = ts - this.lastReq;
        if ( this.lastReq > 0 && dif < this.reqDelay ) { // institute delay 
            this.reqTimer = setTimeout( function() { dw_Tooltip.Ajax.send(queryStr, id); }, this.reqDelay - dif);
        } else {
            dw_Tooltip.Ajax.send( queryStr, id );
        }
    },
    
    send: function (reqData, id) {
        var obj = dw_Tooltip.content_vars[id];
        // page that performs the query, can specify in dw_Tooltip.Ajax.reqURL or 
        // each could have separate url specified in content_vars url prop
        var url = obj['url']? obj['url']: this.reqURL;
        
        // hold timestamp and use to control rate of requests
        var ts = this.lastReq = new Date().getTime();
        url += '?' + reqData + '&rnd=' + ts; 
        
        var callback = { // set success and failure handlers
            success: function(req) { dw_Tooltip.Ajax.handleResponse(req, id); },
            failure: this.handleFailure
        }
        
        this.request = dw_XHR.makeRequest(url, callback );
    },
    
    handleResponse: function (req, id) {
        // if responseText is tooltip content 
        var msg = req.responseText;
        var _this = dw_Tooltip.Ajax;
        
        // if json or xml result, could  parse here 
        // could use id to save result in content_vars and set 'static'
        
        _this.respRecd = true;
        _this.writeTip(msg, true); dw_Tooltip.adjust();
        _this.request = null; // dereference when done
    },
    
    handleFailure: function () {
        // message on failure? 
        var msg = 'Data unavailable';
        dw_Tooltip.Ajax.respRecd = true;
        dw_Tooltip.Ajax.writeTip(msg, true);
        dw_Tooltip.adjust();
    },
    
    writeTip: function(msg, bReqFlag) {
        var _this = dw_Tooltip.Ajax;
        if ( _this.pendingReq && _this.respRecd && !bReqFlag ) return;
        msg = dw_Tooltip.wrapFn(msg); dw_Tooltip.tip.innerHTML = msg;
    },
    
    resetRequest: function () {
        var _this = dw_Tooltip.Ajax;
        if ( _this.request ) { _this.request.abort(); }
        _this.respRecd = false; _this.pendingReq = false;
        if ( _this.reqTimer ) { clearTimeout( _this.reqTimer ); _this.reqTimer = 0; }
    }
    
}

dw_Tooltip.writeTip = dw_Tooltip.Ajax.writeTip;
dw_Tooltip.resetRequest = dw_Tooltip.Ajax.resetRequest;
