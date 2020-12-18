//
//  File.swift
//  
//
//  Created by Roderic Campbell on 12/5/20.
//

import Foundation

extension String {
    var capitalizeFirst: String {
        prefix(1).capitalized + dropFirst()
    }
}

extension Character {
    var isUppercase: Bool { return String(self).uppercased() == String(self) }
}


extension String {

    func capitalizeAndSplit() -> String {
        let indexes = Set(self
                            .enumerated()
                            .filter { $0.element.isUppercase }
                            .map { $0.offset })

        let chunks = self
            .map { String($0) }
            .enumerated()
            .reduce([String]()) { chunks, elm -> [String] in
                guard !chunks.isEmpty else { return [elm.element] }
                guard !indexes.contains(elm.offset) else { return chunks + [String(elm.element)] }

                var chunks = chunks
                chunks[chunks.count-1] += String(elm.element)
                return chunks
            }
        return chunks.joined(separator: " ")
    }
}

public struct Italy {
    public static let title = "Italy"
    public enum Tuscany: String, AppelationDescribable, CaseIterable  {

        public static let title = "Tuscany"
        public init?(_ appellation: String) {
            switch appellation {
            case "Chianti Classico DOCG":
                self = .chiantiClassicoDOP
            case "Brunello di Montalcino":
                self = .brunellodiMontalcinoDOP
            default:
                return nil
            }
        }
        public var description: String {

            // Ultimately this capitalizes the string and splits on the capitals so "abcDeFG" becomes "Abc De Fg"
            // We also replace D O P with DOP and a few other simple replacements
            let doctoredString = rawValue.capitalizeAndSplit()
            return doctoredString
                .capitalized
                .replacingOccurrences(of: "D O P", with: "DOP")
                .replacingOccurrences(of: "I G P", with: "IGP")
                .replacingOccurrences(of: "O I G P", with: "OIGP")
                .replacingOccurrences(of: "_", with: "")
        }

        public var url: URL {
            URL(string: "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/Italy/\(urlableName).geojson")!

        }

        private var urlableName: String {
            self.rawValue
                .capitalizeFirst
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "dop", with: "DOP")
                .replacingOccurrences(of: "_", with: "-")
        }
        case abruzzoDOP
        //            case affileCesanesediAffileDOP
        case aglianicodelTaburnoDOP
        case aglianicodelVultureDOP
        case aglianicodelVultureSuperioreDOP
        case albaDOP
        case albugnanoDOP
        case alcamoDOP
        case aleaticoPassitodellElbaElbaAleaticoPassitoDOP
        case aleaticodiGradoliDOP
        case aleaticodiPugliaDOP
        case alezioDOP
        case algheroDOP
        case alleronaIGP
        case alpiReticheIGP
        case altaLangaDOP
        case altaValledellaGreveIGP
        //            case altoAdigeSfcdtirolSfcdtirolerdellAltoAdigeDOP
        case altoLivenzaIGP
        case altoMincioIGP
        case amaronedellaValpolicellaDOP
        case ameliaDOP
        case anagniIGP
        //            case ansonicaCostadellArgentarioDOP
        case apriliaDOP
        case arboreaDOP
        case arcoleDOP
        case arghille0IGP
        case asolo_ProseccoColliAsolani_ProseccoDOP
        case assisiDOP
        case astiDOP
        case atinaDOP
        case aversaDOP
        case avolaIGP
        case bagnoliBagnolidiSopraDOP
        case bagnoliFriularoFriularodiBagnoliDOP
        case barbagiaIGP
        case barbarescoDOP
        case barberadAlbaDOP
        case barberadAstiDOP
        case barberadelMonferratoDOP
        case barberadelMonferratoSuperioreDOP
        case barcoRealediCarmignanoDOP
        case bardolinoDOP
        case bardolinoSuperioreDOP
        case barlettaDOP
        case baroloDOP
        case basilicataIGP
        case benacoBrescianoIGP
        case beneventoBeneventanoIGP
        case bergamascaIGP
        case bettonaIGP
        case bianchellodelMetauroDOP
        case biancoCapenaDOP
        case biancodelSillaroSillaroIGP
        case biancodellEmpoleseDOP
        case biancodiCastelfrancoEmiliaIGP
        case biancodiCustozaCustozaDOP
        case biancodiPitiglianoDOP
        case bifernoDOP
        case bivongiDOP
        case bocaDOP
        case bolgheriDOP
        case bolgheriSassicaiaDOP
        case bonardadellOltrepf2PaveseDOP
        case boscoEliceoDOP
        case botticinoDOP
        case brachettodAcquiAcquiDOP
        case bramaterraDOP
        case breganzeDOP
        case brindisiDOP
        case brunelloDiMontalcino// = "Brunello di Montalcino"
        case brunellodiMontalcinoDOP
        case buttafuocoButtafuocodellOltrepf2PaveseDOP
        case caccemmittediLuceraDOP
        case cagliariDOP
        case calabriaIGP
        //            case caldaroKaltererKaltererseeLagodiCaldaroDOP
        case calossoDOP
        case camarroIGP
        case campaniaIGP
        case campiFlegreiDOP
        case campidanodiTerralbaTerralbaDOP
        case canaveseDOP
        case candiadeiColliApuaniDOP
        case cannaraIGP
        case cannellinodiFrascatiDOP
        case cannonaudiSardegnaDOP
        case capalbioDOP
        case capriDOP
        case caprianodelColleDOP
        case caremaDOP
        case carignanodelSulcisDOP
        case carmignanoDOP
        case carsoCarso_KrasDOP
        case casavecchiadiPontelatoneDOP
        case casteggioDOP
        case castelSanLorenzoDOP
        case casteldelMonteBombinoNeroDOP
        case casteldelMonteDOP
        case casteldelMonteNerodiTroiaDOP
        case casteldelMonteRossoRiservaDOP
        case castellerDOP
        case castelliRomaniDOP
        case castellidiJesiVerdicchioRiservaDOP
        case catalanescadelMonteSommaSommaIGP
        case cellaticaDOP
        case cerasuolodAbruzzoDOP
        //            case cerasuolodiVittoriaDOP
        case cerveteriDOP
        case cesanesedelPiglioPiglioDOP
        case cesanesediOlevanoRomanoOlevanoRomanoDOP
        case cf2neroDOP
        case chiantiClassico
        case chiantiClassicoDOP
        case chiantiDOP
        case cilentoDOP
        case cinqueTerreCinqueTerreSciacchetre0DOP
        case circeoDOP
        case cirf2DOP
        case cisternadAstiDOP
        case civitellad92AglianoIGP
        case colliAlbaniDOP
        case colliAltotiberiniDOP
        case colliAprutiniIGP
        case colliBericiDOP
        case colliBolognesiClassicoPignolettoDOP
        case colliBolognesiDOP
        case colliCiminiIGP
        case colliEtruschiViterbesiTusciaDOP
        case colliEuganeiDOP
        case colliEuganeiFiord92ArancioFiordArancioColliEuganeiDOP
        case colliLanuviniDOP
        case colliMaceratesiDOP
        case colliMartaniDOP
        case colliOrientalidelFriuliPicolitDOP
        case colliPeruginiDOP
        case colliPesaresiDOP
        //            case colliPiacentiniDOP
        case colliRomagnaCentraleDOP
        case colliTortonesiDOP
        case colliTrevigianiIGP
        case collidImolaDOP
        case collidelLimbaraIGP
        case collidelSangroIGP
        case collidelTrasimenoTrasimenoDOP
        case collidellEtruriaCentraleDOP
        case collidellaSabinaDOP
        case collidellaToscanacentraleIGP
        case collidiConeglianoDOP
        case collidiFaenzaDOP
        case collidiLuniDOP
        case collidiParmaDOP
        case collidiRiminiDOP
        case collidiSalernoIGP
        case collidiScandianoediCanossaDOP
        case collinaTorineseDOP
        case collinadelMilaneseIGP
        case collineFrentaneIGP
        case collineJonicheTarantineDOP
        case collineLucchesiDOP
        case collineNovaresiDOP
        case collinePescaresiIGP
        case collineSaluzzesiDOP
        case collineSavonesiIGP
        case collineTeatineIGP
        case collinedelGenovesatoIGP
        case collinediLevantoDOP
        case collioGorizianoCollioDOP
        case conegliano_ProseccoConeglianoValdobbiadene_ProseccoValdobbiadene_ProseccoDOP
        case conselvanoIGP
        case conteadiSclafaniValledolmo_ConteadiSclafaniDOP
        case contessaEntellinaDOP
        case controguerraDOP
        case copertinoDOP
        case coriDOP
        case cortesedellAltoMonferratoDOP
        case cortesediGaviGaviDOP
        case cortiBenedettinedelPadovanoDOP
        case cortonaDOP
        case costaEtruscoRomanaIGP
        case costaToscanaIGP
        case costaViolaIGP
        case costadAmalfiDOP
        case costedellaSesiaDOP
        case curtefrancaDOP
        case dauniaIGP
        case delVasteseHistoniumIGP
        case deliaNivolelliDOP
        case doglianiDOP
        case dolceacquaRossesediDolceacquaDOP
        case dolcettodAcquiDOP
        case dolcettodAlbaDOP
        case dolcettodAstiDOP
        case dolcettodiDianod92AlbaDianod92AlbaDOP
        case dolcettodiOvadaDOP
        case dolcettodiOvadaSuperioreOvadaDOP
        case dugentaIGP
        case elbaDOP
        case eloroDOP
        case emiliadellEmiliaIGP
        case epomeoIGP
        case erbalucediCalusoCalusoDOP
        case ericeDOP
        case esinoDOP
        //            case est!Est!!Est!!!diMontefiasconeDOP
        case estDiMontefiasconeDOP = "est!Est!!Est!!!diMontefiasconeDOP"
        case etnaDOP
        //            case falanghinadelSannioDOP
        case falerioDOP
        case falernodelMassicoDOP
        case faraDOP
        case faroDOP
        case fianodiAvellinoDOP
        case fontanarossadiCerdaIGP
        case forlecIGP
        case fortanadelTaroIGP
        case franciacortaDOP
        case frascatiDOP
        case frascatiSuperioreDOP
        case freisadAstiDOP
        case freisadiChieriDOP
        case friuliAnniaDOP
        case friuliAquileiaDOP
        case friuliColliOrientaliDOP
        case friuliGraveDOP
        case friuliIsonzoIsonzodelFriuliDOP
        case friuliLatisanaDOP
        case fruiuliAquileia
        case frusinatedelFrusinateIGP
        case gabianoDOP
        case galatinaDOP
        case galluccioDOP
        case gambellaraDOP
        case gardaBrescianoRivieradelGardaBrescianoDOP
        case gardaColliMantovaniDOP
        //            case gardaDOP
        case gattinaraDOP
        case genazzanoDOP
        //            case ghemmeDOP
        case gioiadelColleDOP
        case girf2diCagliariDOP
        case golfodelTigullio_PortofinoPortofinoDOP
        case granceSenesiDOP
        case gravinaDOP
        case grecodiBiancoDOP
        case grecodiTufoDOP
        case grignolinodAstiDOP
        case grignolinodelMonferratoCasaleseDOP
        case grottinodiRoccanovaDOP
        //            case gutturnioDOP
        case iTerrenidiSanseverinoDOP
        case irpiniaDOP
        case ischiaDOP
        case isoladeiNuraghiIGP
        case lacrimadiMorroLacrimadiMorrodAlbaDOP
        case lagodiCorbaraDOP
        case lambruscoGrasparossadiCastelvetroDOP
        case lambruscoMantovanoDOP
        case lambruscoSalaminodiSantaCroceDOP
        case lambruscodiSorbaraDOP
        case lameziaDOP
        case langheDOP
        case lazioIGP
        case lessiniDurelloDurelloLessiniDOP
        case lessonaDOP
        case leveranoDOP
        case liguriadiLevanteIGP
        case lipudaIGP
        case lisonDOP
        //            case lisonPramaggioreDOP
        case lizzanoDOP
        case loazzoloDOP
        case locorotondoDOP
        case locrideIGP
        case luganaDOP
        case malanottedelPiavePiaveMalanotteDOP
        case malvasiadelleLipariDOP
        case malvasiadiBosaDOP
        case malvasiadiCasorzodAstiCasorzoMalvasiadiCasorzoDOP
        case malvasiadiCastelnuovoDonBoscoDOP
        case mamertinoMamertinodiMilazzoDOP
        case mandrolisaiDOP
        case marcaTrevigianaIGP
        case marcheIGP
        case maremmaToscanaDOP
        case marinoDOP
        case marmillaIGP
        case marsalaDOP
        case martinaMartinaFrancaDOP
        case materaDOP
        case matinoDOP
        case melissaDOP
        case menfiDOP
        case merlaraDOP
        case mitterbergIGP
        case modenadiModenaDOP
        case molisedelMoliseDOP
        case monferratoDOP
        case monicadiSardegnaDOP
        case monrealeDOP
        case montecarloDOP
        case montecastelliIGP
        case montecompatriColonnaMontecompatriColonnaDOP
        case montecuccoDOP
        case montecuccoSangioveseDOP
        case montefalcoDOP
        case montefalcoSagrantinoDOP
        case montello_ColliAsolaniDOP
        case montelloMontelloRossoDOP
        case montenettodiBresciaIGP
        case montepulcianodAbruzzoCollineTeramaneDOP
        case montepulcianodAbruzzoDOP
        case monteregiodiMassaMarittimaDOP
        case montescudaioDOP
        case montiLessiniDOP
        case morellinodiScansanoDOP
        case moscadellodiMontalcinoDOP
        case moscatodiSardegnaDOP
        case moscatodiSorso_SennoriMoscatodiSorsoMoscatodiSennoriDOP
        case moscatodiTraniDOP
        case murgiaIGP
        case nardf2DOP
        case narniIGP
        case nascodiCagliariDOP
        case nebbiolodAlbaDOP
        case negroamarodiTerradOtrantoDOP
        case nettunoDOP
        case nizzaDOP
        case notoDOP
        case nuragusdiCagliariDOP
        case nurraIGP
        case offidaDOP
        case ogliastraIGP
        case oltrepf2PaveseDOP
        case oltrepf2PavesePinotgrigioDOP
        case oltrepf2PavesemetodoclassicoDOP
        case orciaDOP
        case ormeascodiPornassioPornassioDOP
        case ortaNovaDOP
        case ortonaDOP
        //            case ortrugodeiColliPiacentiniOrtrugoColliPiacentiniDOP
        case orvietanoRossoRossoOrvietanoDOP
        case orvietoDOP
        case oscoTerredegliOsciIGP
        case ostuniDOP
        case paestumIGP
        case palizziIGP
        case pantelleriaDOP
        case parrinaDOP
        case parteollaIGP
        case pellaroIGP
        case penisolaSorrentinaDOP
        case pentroPentrodiIserniaDOP
        case pergolaDOP
        case piaveDOP
        case piedmont
        case piemonteDOP
        case pineroleseDOP
        case pinotnerodellOltrepf2PaveseDOP
        case planargiaIGP
        case pominoDOP
        case pompeianoIGP
        case primitivodiManduriaDOP
        case primitivodiManduriaDolceNaturaleDOP
        case proseccoDOP
        case provinciadiMantovaIGP
        case provinciadiNuoroIGP
        case provinciadiPaviaIGP
        case pugliaIGP
        case quistelloIGP
        case ramandoloDOP
        case ravennaIGP
        case reciotodellaValpolicellaDOP
        case reciotodiGambellaraDOP
        //            case reciotodiSoaveDOP
        case reggianoDOP
        case renoDOP
        case riesiDOP
        //            case rivieradelBrentaDOP
        //            case rivieraligurediPonenteDOP
        case roccamonfinaIGP
        case roeroDOP
        case romaDOP
        case romagnaAlbanaDOP
        case romagnaDOP
        case romangiaIGP
        case ronchiVaresiniIGP
        case ronchidiBresciaIGP
        case rosazzoDOP
        case rossoCf2neroDOP
        case rossoPicenoPicenoDOP
        case rossodellaValdiCorniaValdiCorniaRossoDOP
        case rossodiCerignolaDOP
        case rossodiMontalcinoDOP
        //            case rossodiMontepulcianoDOP
        case rotaeIGP
        case rubiconeIGP
        case rubinodiCantavennaDOP
        case ruche9diCastagnoleMonferratoDOP
        case s_AnnadiIsolaCapoRizzutoDOP = "S.AnnadiIsolaCapoRizzutoDOP"
        case sabbionetaIGP
        case salaparutaDOP
        case salemiIGP
        case salentoIGP
        case saliceSalentinoDOP
        case salinaIGP
        case sambucadiSiciliaDOP
        case sanColombanoSanColombanoalLambroDOP
        case sanGimignanoDOP
        case sanGinesioDOP
        case sanMartinodellaBattagliaDOP
        case sanSeveroDOP
        case sanTorpe8DOP
        case sanguediGiudaSanguediGiudadellOltrepf2PaveseDOP
        //            case sanfnioDOP
        case santAntimoDOP
        case santaMargheritadiBeliceDOP
        case sardegnaSemidanoDOP
        case savutoDOP
        case scanzoMoscatodiScanzoDOP
        case scavignaDOP
        case sciaccaDOP
        case scillaIGP
        case sebinoIGP
        case serenissimaVignetidellaSerenissimaDOP
        case serrapetronaDOP
        case sforzatodiValtellinaSfursatdiValtellinaDOP
        case sibiolaIGP
        case siciliaDOP
        case siracusaDOP
        case sizzanoDOP
        case soaveDOP
        case soaveSuperioreDOP
        case sovanaDOP
        case spelloIGP
        case spoletoDOP
        case squinzanoDOP
        case streviDOP
        case suveretoDOP
        case tarantinoIGP
        case tarquiniaDOP
        case taurasiDOP
        case tavoliereTavolieredellePuglieDOP
        case teroldegoRotalianoDOP
        case terracinaMoscatodiTerracinaDOP
        case terradOtrantoDOP
        case terradeifortiValdadigeTerradeifortiDOP
        case terraticodiBibbonaDOP
        case terrazzedellImperieseIGP
        case terreAlfieriDOP
        case terreAquilaneTerredeLAquilaIGP
        case terreLarianeIGP
        case terreSicilianeIGP
        case terreTollesiTullumDOP
        case terredelColleoniColleoniDOP
        case terredelVolturnoIGP
        case terredellAltaValdAgriDOP
        case terrediCasoleDOP
        case terrediChietiIGP
        case terrediCosenzaDOP
        case terrediOffidaDOP
        case terrediPisaDOP
        case terrediVelejaIGP
        case tharrosIGP
        case tintiliadelMoliseDOP
        case todiDOP
        case torgianoDOP
        case torgianoRossoRiservaDOP
        case toscanoToscanaIGP
        case trebbianodAbruzzoDOP
        case trentinoDOP
        case trentoDOP
        case trexentaIGP
        case umbria
        case umbriaIGP
        case valPolce8veraDOP
        case valTidoneIGP
        case valcalepioDOP
        case valcamonicaIGP
        case vald92ArbiaDOP
        case vald92ArnodiSopraValdarnodiSopraDOP
        case valdadigeEtschtalerDOP
        case valdamatoIGP
        case valdiCorniaDOP
        case valdiMagraIGP
        case valdiNetoIGP
        case valdichianatoscanaDOP
        case valdinievoleDOP
        case vallagarinaIGP
        case valleBeliceIGP
        case valled92ItriaIGP
        //            case valledAostaValle9edAosteDOP
        case valledelTirsoIGP
        case valliOssolaneDOP
        case vallidiPortoPinoIGP
        case valpolicellaDOP
        case valpolicellaripassoDOP
        case valsusaDOP
        case valte8nesiDOP
        case valtellinaSuperioreDOP
        case valtellinarossoRossodiValtellinaDOP
        case velletriDOP
        case veneto
        case venetoIGP
        case venetoorientaleIGP
        case veneziaDOP
        case veneziaGiuliaIGP
        case verdicchiodeiCastellidiJesiDOP
        case verdicchiodiMatelicaDOP
        case verdicchiodiMatelicaRiservaDOP
        case verdunoPelavergaVerdunoDOP
        case vermentinodiGalluraDOP
        case vermentinodiSardegnaDOP
        case vernacciadiOristanoDOP
        case vernacciadiSanGimignanoDOP
        case vernacciadiSerrapetronaDOP
        case veronaVeroneseProvinciadiVeronaIGP
        case vesuvioDOP
        case vicenzaDOP
        case vignanelloDOP
        case vignetidelleDolomitiWeinbergDolomitenIGP
        case villamagnaDOP
        case vinSantodelChiantiClassicoDOP
        case vinSantodelChiantiDOP
        case vinSantodiCarmignanoDOP
        case vinSantodiMontepulcianoDOP
        case vinoNobilediMontepulcianoDOP
        case vittoriaDOP
        case zagaroloDOP
    }

}
