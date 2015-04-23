/*
 * API服务
 *
 * 异常号段：
 */

include "Type.thrift"

namespace java com.wisorg.scc.api.center.internal.apiscope
namespace js ApiScope
namespace cocoa ApiScope

/**
 * 开放的service
 */
struct TOpenService {

	/**
     * scope作用域
     */
    1: optional string id
}


struct TApiScope {

	/**
     * scope作用域
     */
    1: optional string scope,
    
    /**
     * API集合
     */
    2: optional list<string> apiList
}


struct TApiResult {
	1: optional list<TOpenService> serviceList,
	2: optional list<TApiScope> apiList
}


/**
 * ApiScope服务
 */
service OApiScopeService {

	/**
     * 获得Api列表.
     */
    TApiResult queryApi(
    )throws (
        1: Type.TSccException ex
    )
}
