//
//  UtilDTO.swift
//  OneThing
//
//  Created by 윤동주 on 3/23/25.
//

import Foundation

enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
    case none = "NONE"
}

enum DeviceType: String, Encodable {
    case iOS = "iOS"
    case android = "ANDROID"
}

struct County: Equatable {
    var code: String
    var name: String
}

enum City: String, CaseIterable {
    case seoul = "서울"
    case busan = "부산"
    case daegu = "대구"
    case incheon = "인천"
    case gwangju = "광주"
    case daejeon = "대전"
    case ulsan = "울산"
    case sejong = "세종"
    case gyeonggi = "경기"
    case chungbuk = "충북"
    case gangwon = "강원"
    case chungnam = "충남"
    case jeonbuk = "전북"
    case jeonnam = "전남"
    case gyeongbuk = "경북"
    case gyeongnam = "경남"
    case jeju = "제주"
    
    var englishCode: String {
        switch self {
        case .seoul:
            return "SEOUL"
        case .busan:
            return "BUSAN"
        case .daegu:
            return "DAEGU"
        case .incheon:
            return "INCHEON"
        case .gwangju:
            return "GWANGJU"
        case .daejeon:
            return "DAEJEON"
        case .ulsan:
            return "ULSAN"
        case .sejong:
            return "SEJONG"
        case .gyeonggi:
            return "GYEONGGI"
        case .chungbuk:
            return "CHUNGBUK"
        case .gangwon:
            return "GANGWON"
        case .chungnam:
            return "CHUNGNAM"
        case .jeonbuk:
            return "JEONBUK"
        case .jeonnam:
            return "JEONNAM"
        case .gyeongbuk:
            return "GYEONGBUK"
        case .gyeongnam:
            return "GYEONGNAM"
        case .jeju:
            return "JEJU"
        }
    }
    
    var counties: [County] {
        switch self {
        case .seoul:
            return [
                County(code: "GANGNAM",    name: "강남구"),
                County(code: "GANGDONG",   name: "강동구"),
                County(code: "GANGBUK",    name: "강북구"),
                County(code: "GANGSEO",    name: "강서구"),
                County(code: "GWANAK",     name: "관악구"),
                County(code: "GWANGJIN",   name: "광진구"),
                County(code: "GURO",       name: "구로구"),
                County(code: "GEUMCHEON",  name: "금천구"),
                County(code: "NOWON",      name: "노원구"),
                County(code: "DOBONG",     name: "도봉구"),
                County(code: "DDM",        name: "동대문구"),
                County(code: "DONGJAK",    name: "동작구"),
                County(code: "MAPO",       name: "마포구"),
                County(code: "SDM",        name: "서대문구"),
                County(code: "SEOCHO",     name: "서초구"),
                County(code: "SEONGDONG",  name: "성동구"),
                County(code: "SEONGBUK",   name: "성북구"),
                County(code: "SONGPA",     name: "송파구"),
                County(code: "YANGCHEON",  name: "양천구"),
                County(code: "YDP",        name: "영등포구"),
                County(code: "YONGSAN",    name: "용산구"),
                County(code: "EUNPYEONG",  name: "은평구"),
                County(code: "JONGNO",     name: "종로구"),
                County(code: "JUNGGU",       name: "중구"),
                County(code: "JUNGNANG",   name: "중랑구")
            ]
        case .busan:
            return [
                County(code: "GANGSEO",    name: "강서구"),
                County(code: "GEUMJEONG",  name: "금정구"),
                County(code: "GIJANG",     name: "기장군"),
                County(code: "NAM",        name: "남구"),
                County(code: "DONG",       name: "동구"),
                County(code: "DONGNAE",    name: "동래구"),
                County(code: "BUSANJIN",   name: "부산진구"),
                County(code: "BUK",        name: "북구"),
                County(code: "SASANG",     name: "사상구"),
                County(code: "SAHA",       name: "사하구"),
                County(code: "SEO",        name: "서구"),
                County(code: "SUYEONG",    name: "수영구"),
                County(code: "YEONJE",     name: "연제구"),
                County(code: "YEONGDO",    name: "영도구"),
                County(code: "JUNG",       name: "중구"),
                County(code: "HAEUNDAE",   name: "해운대구")
            ]
        case .daegu:
            return [
                County(code: "DALSEO",    name: "달서구"),
                County(code: "DALSEONG",  name: "달성군"),
                County(code: "NAM",       name: "남구"),
                County(code: "DONG",      name: "동구"),
                County(code: "BUK",       name: "북구"),
                County(code: "SEO",       name: "서구"),
                County(code: "SUSEONG",   name: "수성구"),
                County(code: "JUNG",      name: "중구"),
            ]
        case .incheon:
            return [
                County(code: "GANGHWA",   name: "강화군"),
                County(code: "DONG",      name: "동구"),
                County(code: "MICHUHOL",  name: "미추홀구"),
                County(code: "BUPYEONG",  name: "부평구"),
                County(code: "SEO",       name: "서구"),
                County(code: "YEONSU",    name: "연수구"),
                County(code: "GYEYANG",   name: "계양구"),
                County(code: "NAMDONG",   name: "남동구"),
                County(code: "ONGJIN",    name: "옹진군"),
                County(code: "JUNG",      name: "중구"),
            ]
        case .gwangju:
            return [
                County(code: "GWANGSAN", name: "광산구"),
                County(code: "NAM",      name: "남구"),
                County(code: "DONG",     name: "동구"),
                County(code: "BUK",      name: "북구"),
                County(code: "SEO",      name: "서구"),
            ]
        case .daejeon:
            return [
                County(code: "DAEDEOK", name: "대덕구"),
                County(code: "DONG",    name: "동구"),
                County(code: "SEO",     name: "서구"),
                County(code: "YUSEONG", name: "유성구"),
                County(code: "JUNG",    name: "중구"),
            ]
        case .ulsan:
            return [
                County(code: "NAM",     name: "남구"),
                County(code: "DONG",    name: "동구"),
                County(code: "BUK",     name: "북구"),
                County(code: "ULJU",    name: "울주군"),
                County(code: "JUNG",    name: "중구"),
            ]
        case .sejong:
            return []
        case .gyeonggi:
            return [
                County(code: "GOYANG",       name: "고양시"),
                County(code: "GWACHEON",     name: "과천시"),
                County(code: "GWANGMYEONG",  name: "광명시"),
                County(code: "GURI",         name: "구리시"),
                County(code: "GUNPO",        name: "군포시"),
                County(code: "NAMYANGJU",    name: "남양주시"),
                County(code: "DONGDUCHEON",  name: "동두천시"),
                County(code: "BUCHEON",      name: "부천시"),
                County(code: "SEONGNAM",     name: "성남시"),
                County(code: "SUWON",        name: "수원시"),
                County(code: "SIHEUNG",      name: "시흥시"),
                County(code: "ANSAN",        name: "안산시"),
                County(code: "ANYANG",       name: "안양시"),
                County(code: "YANGJU",       name: "양주시"),
                County(code: "OSAN",         name: "오산시"),
                County(code: "YONGIN",       name: "용인시"),
                County(code: "UIWANG",       name: "의왕시"),
                County(code: "UIJEONGBU",    name: "의정부시"),
                County(code: "PYEONGTAEK",   name: "평택시"),
                County(code: "HANAM",        name: "하남시"),
            ]
        case .chungbuk:
            return [
                County(code: "GOESAN",       name: "괴산군"),
                County(code: "DANYANG",      name: "단양군"),
                County(code: "BOEUN",        name: "보은군"),
                County(code: "SANGDANG",      name: "상당구"),
                County(code: "SEOWON",        name: "서원구"),
                County(code: "YEONGDONG",    name: "영동군"),
                County(code: "OKCHEON",      name: "옥천군"),
                County(code: "EUMSEONG",     name: "음성군"),
                County(code: "JECHEON",       name: "제천시"),
                County(code: "JEUNGPYEONG",  name: "증평군"),
                County(code: "JINCHEON",     name: "진천군"),
                County(code: "CHEONGWON",     name: "청원구"),
                County(code: "CHEONGJU",      name: "청주시"),
                County(code: "CHUNGJU",       name: "충주시"),
                County(code: "HEUNGDEOK",     name: "흥덕구")
            ]
        case .gangwon:
            return [
                County(code: "GANGNEUNG",    name: "강릉시"),
                County(code: "GOSEONG",     name: "고성군"),
                County(code: "DONGHAE",      name: "동해시"),
                County(code: "SAMCHEOK",     name: "삼척시"),
                County(code: "YANGGU",      name: "양구군"),
                County(code: "YEONGWOL",    name: "영월군"),
                County(code: "WONJU",        name: "원주시"),
                County(code: "INJE",        name: "인제군"),
                County(code: "JEONGSEON",   name: "정선군"),
                County(code: "CHEORWON",    name: "철원군"),
                County(code: "CHUNCHEON",    name: "춘천시"),
                County(code: "TAEBAEK",      name: "태백시"),
                County(code: "PYEONGCHANG", name: "평창군"),
                County(code: "HONGCHEON",   name: "홍천군"),
                County(code: "HWACHEON",    name: "화천군"),
                County(code: "HOENGSEONG",  name: "횡성군")
            ]
        case .chungnam:
            return [
                County(code: "GYERYONG",     name: "계룡시"),
                County(code: "GONGJU",       name: "공주시"),
                County(code: "GEUMSAN",     name: "금산군"),
                County(code: "NONSAN",       name: "논산시"),
                County(code: "DANGJIN",      name: "당진시"),
                County(code: "BORYEONG",     name: "보령시"),
                County(code: "BUYEO",       name: "부여군"),
                County(code: "SEOSAN",       name: "서산시"),
                County(code: "SEOCHEON",    name: "서천군"),
                County(code: "ASAN",         name: "아산시"),
                County(code: "YESAN",       name: "예산군"),
                County(code: "CHEONAN",      name: "천안시"),
                County(code: "CHEONGYANG",  name: "청양군"),
                County(code: "TAEAN",       name: "태안군"),
                County(code: "HONGSEONG",   name: "홍성군")
            ]
        case .jeonbuk:
            return [
                County(code: "GOCHANG", name: "고창군"),
                County(code: "GUNSAN",   name: "군산시"),
                County(code: "JEONGEUP", name: "정읍시"),
                County(code: "JEONJU",   name: "전주시"),
                County(code: "JINAN",   name: "진안군"),
                County(code: "GIMJE",    name: "김제시"),
                County(code: "NAMWON",   name: "남원시"),
                County(code: "MUJU",    name: "무주군"),
                County(code: "BUAN",    name: "부안군"),
                County(code: "SUNCHANG",name: "순창군"),
                County(code: "IKSAN",    name: "익산시"),
                County(code: "IMSIL",   name: "임실군"),
                County(code: "WANJU",   name: "완주군"),
                County(code: "JANGSEONG", name: "장성군"),
                County(code: "JANGSU",  name: "장수군"),
            ]
        case .jeonnam:
            return [
                County(code: "GANGJIN",   name: "강진군"),
                County(code: "GWANGYANG",  name: "광양시"),
                County(code: "GOHEUNG",   name: "고흥군"),
                County(code: "GURYE",     name: "구례군"),
                County(code: "GOKSEONG",  name: "곡성군"),
                County(code: "DAMYANG",   name: "담양군"),
                County(code: "NAMHAE",    name: "남해군"),
                County(code: "MUAN",      name: "무안군"),
                County(code: "BOSUNG",    name: "보성군"),
                County(code: "SINAN",     name: "신안군"),
                County(code: "YEONGAM",   name: "영암군"),
                County(code: "YEONGGWANG",name: "영광군"),
                County(code: "WANDO",     name: "완도군"),
                County(code: "JANGSEONG", name: "장성군"),
                County(code: "JANGHEUNG", name: "장흥군"),
                County(code: "JINDO",     name: "진도군"),
                County(code: "HAMPYEONG", name: "함평군"),
                County(code: "HAENAM",    name: "해남군"),
                County(code: "HWASUN",    name: "화순군"),
            ]
        case .gyeongbuk:
            return [
                County(code: "GEOCHANG",  name: "거창군"),
                County(code: "GORYEONG",  name: "고령군"),
                County(code: "GYEONGSAN",  name: "경산시"),
                County(code: "GYEONGJU",   name: "경주시"),
                County(code: "GUMI",       name: "구미시"),
                County(code: "GIMCHEON",   name: "김천시"),
                County(code: "BONGHWA",   name: "봉화군"),
                County(code: "SANGJU",    name: "상주시"),
                County(code: "SEONGJU",   name: "성주군"),
                County(code: "MUNGYEONG",  name: "문경시"),
                County(code: "POHANG",     name: "포항시"),
                County(code: "ANDONG",     name: "안동시"),
                County(code: "ULLEUNG",   name: "울릉군"),
                County(code: "ULJIN",     name: "울진군"),
                County(code: "YEONGDEOK", name: "영덕군"),
                County(code: "YEONGCHEON", name: "영천시"),
                County(code: "YEONGYANG", name: "영양군"),
                County(code: "YECHEON",   name: "예천군"),
            ]
            
        case .gyeongnam:
            return [
                County(code: "GEOJE",      name: "거제시"),
                County(code: "GIMHAE",     name: "김해시"),
                County(code: "MIRYANG",    name: "밀양시"),
                County(code: "SACHEON",    name: "사천시"),
                County(code: "SANCHO",    name: "산청군"),
                County(code: "YANGSAN",    name: "양산시"),
                County(code: "YANGPYEONG",name: "양평군"),
                County(code: "YEOJU",      name: "여주시"),
                County(code: "CHANGWON",   name: "창원시"),
                County(code: "HADONG",    name: "하동군"),
                County(code: "HAMAN",     name: "함안군"),
                County(code: "HAMYANG",   name: "함양군"),
                County(code: "HAPCHEON",  name: "합천군"),
                County(code: "JINJU",      name: "진주시"),
                County(code: "TONGYEONG",  name: "통영시"),
            ]
        case .jeju:
            return [
                County(code: "JEJU",      name: "제주시"),
                County(code: "SEOGWIPO", name: "서귀포시")
            ]
        }
    }
    
    func getCountyCode(for city: City, countyName: String) -> String? {
        return city.counties.first(where: { $0.name == countyName })?.code
    }
}
