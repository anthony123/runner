//
//  BadgeEarnStatus.swift
//  Runner
//
//  Created by liuwq on 16/6/11.
//  Copyright © 2016年 liuwq. All rights reserved.
//

import Foundation

struct BadgeEarnStatus
{
    var badge:Badge?
    var earnRun:Run?
    var silverRun:Run?
    var goldRun:Run?
    var bestRun:Run?
    
    init()
    {
        badge = nil
        earnRun = nil
        silverRun = nil
        goldRun = nil
        bestRun = nil
    }
}