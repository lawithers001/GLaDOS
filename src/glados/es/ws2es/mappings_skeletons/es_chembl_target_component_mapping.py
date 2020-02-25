# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 1

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        '_doc': 
        {
            'properties': 
            {
                'accession': 'TEXT',
                # EXAMPLES:
                # 'P33527' , 'P15944' , 'Q96K76' , 'P09917' , 'P31390' , 'Q9UK80' , 'P10827' , 'P15101' , 'Q96RU2' , 'P1
                # 1229'
                'component_id': 'NUMERIC',
                # EXAMPLES:
                # '1333' , '3018' , '6836' , '168' , '3019' , '6837' , '169' , '3020' , '6838' , '170'
                'component_type': 'TEXT',
                # EXAMPLES:
                # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTE
                # IN' , 'PROTEIN'
                'description': 'TEXT',
                # EXAMPLES:
                # 'Multidrug resistance-associated protein 1' , 'Tryptase' , 'Ubiquitin carboxyl-terminal hydrolase 47' 
                # , 'Arachidonate 5-lipoxygenase' , 'Histamine H1 receptor' , 'Ubiquitin carboxyl-terminal hydrolase 21'
                #  , 'Thyroid hormone receptor alpha' , 'Dopamine beta-hydroxylase' , 'Ubiquitin carboxyl-terminal hydro
                # lase 28' , 'Muscarinic acetylcholine receptor M1'
                'go_slims': 
                {
                    'properties': 
                    {
                        'go_id': 'TEXT',
                        # EXAMPLES:
                        # 'GO:0000166' , 'GO:0004252' , 'GO:0005515' , 'GO:0002376' , 'GO:0002376' , 'GO:0003674' , 'GO:
                        # 0003674' , 'GO:0003824' , 'GO:0005515' , 'GO:0003674'
                    }
                },
                'organism': 'TEXT',
                # EXAMPLES:
                # 'Homo sapiens' , 'Canis lupus familiaris' , 'Homo sapiens' , 'Homo sapiens' , 'Rattus norvegicus' , 'H
                # omo sapiens' , 'Homo sapiens' , 'Bos taurus' , 'Homo sapiens' , 'Homo sapiens'
                'protein_classifications': 
                {
                    'properties': 
                    {
                        'protein_classification_id': 'NUMERIC',
                        # EXAMPLES:
                        # '1133' , '38' , '74' , '10' , '541' , '1' , '352' , '10' , '74' , '559'
                    }
                },
                'sequence': 'TEXT',
                # EXAMPLES:
                # 'MALRGFCSADGSDPLWDWNVTWNTSNPDFTKCFQNTVLVWVPCFYLWACFPFYFLYLSRHDRGYIQMTPLNKTKTALGFLLWIVCWADLFYSFWERSRGIF
                # LAPVFLVSPTLLGITMLLATFLIQLERRKGVQSSGIMLTFWLVALVCALAILRSKIMTALKEDAQVDLFRDITFYVYFSLLLIQLVLSCFSDRSPLFSETIH
                # DPNPCPESSASFLSRITFWWITGLIVRGYRQPLEGSDLWSLNKEDTSEQVVPVLVKNWKKECAKTRKQPVKVVYSSKDPAQPKESSKVDANEEVEALIVKSP
                # QKEWNPSLFKVLYKTFGPYFLMSFFFKAIHDLMMFSGPQILKLLIKFVNDTKAPDWQGYFYTVLLFVTACLQTLVLHQYFHICFVSGMRIKTAVIGAVYRKA
                # LVITNSARKSSTVGEIVNLMSVDAQRFMDLATYINMIWSAPLQVILALYLLWLNLGPSVLAGVAVMVLMVPVNAVMAMKTKTYQVAHMKSKDNRIKLMNEIL
                # NGIKVLKLYAWELAFKDKVLAIRQEELKVLKKSAYLSAVGTFTWVCTPFLVALCTFAVYVTIDENNILDAQTAFVSLALFNILRFPLNILPMVISSIVQASV
                # SLKRLRIFLSHEELEPDSIERRPVKDGGGTNSITVRNATFTWARSDPPTLNGITFSIPEGALVAVVGQVGCGKSSLLSALLAEMDKVEGHVAIKGSVAYVPQ
                # QAWIQNDSLRENILFGCQLEEPYYRSVIQACALLPDLEILPSGDRTEIGEKGVNLSGGQKQRVSLARAVYSNADIYLFDDPLSAVDAHVGKHIFENVIGPKG
                # MLKNKTRILVTHSMSYLPQVDVIIVMSGGKISEMGSYQELLARDGAFAEFLRTYASTEQEQDAEENGVTGVSGPGKEAKQMENGMLVTDSAGKQLQRQLSSS
                # SSYSGDISRHHNSTAELQKAEAKKEETWKLMEADKAQTGQVKLSVYWDYMKAIGLFISFLSIFLFMCNHVSALASNYWLSLWTDDPIVNGTQEHTKVRLSVY
                # GALGISQGIAVFGYSMAVSIGGILASRCLHVDLLHSILRSPMSFFERTPSGNLVNRFSKELDTVDSMIPEVIKMFMGSLFNVIGACIVILLATPIAAIIIPP
                # LGLIYFFVQRFYVASSRQLKRLESVSRSPVYSHFNETLLGVSVIRAFEEQERFIHQSDLKVDENQKAYYPSIVANRWLAVRLECVGNCIVLFAALFAVISRH
                # SLSAGLVGLSVSYSLQVTTYLNWLVRMSSEMETNIVAVERLKEYSETEKEAPWQIQETAPPSSWPQVGRVEFRNYCLRYREDLDFVLRHINVTINGGEKVGI
                # VGRTGAGKSSLTLGLFRINESAEGEIIIDGINIAKIGLHDLRFKITIIPQDPVLFSGSLRMNLDPFSQYSDEEVWTSLELAHLKDFVSALPDKLDHECAEGG
                # ENLSVGQRQLVCLARALLRKTKILVLDEATAAVDLETDDLIQSTIRTQFEDCTVLTIAHRLNTIMDYTRVIVLDKGEIQEYGAPSDLLQQRGLFYSMAKDAG
                # LV' , 'MPSPLVLALALLGSLVPVSPAPGQALQRVGIVGGREAPGSKWPWQVSLRLKGQYWRHICGGSLIHPQWVLTAAHCVGPNVVCPEEIRVQLREQHL
                # YYQDHLLPVNRIVMHPNYYTPENGADIALLELEDPVNVSAHVQPVTLPPALQTFPTGTPCWVTGWGDVHSGTPLPPPFPLKQVKVPIVENSMCDVQYHLGLS
                # TGDGVRIVREDMLCAGNSKSDSCQGDSGGPLVCRVRGVWLQAGVVSWGEGCAQPNRPGIYTRVAYYLDWIHQYVPKEP' , 'MVPGEENQLVPKEDVFWRC
                # RQNIFDEMKKKFLQIENAAEEPRVLCIIQDTTNSKTVNERITLNLPASTPVRKLFEDVANKVGYINGTFDLVWGNGINTADMAPLDHTSDKSLLDANFEPGK
                # KNFLHLTDKDGEQPQILLEDSSAGEDSVHDRFIGPLPREGSGGSTSDYVSQSYSYSSILNKSETGYVGLVNQAMTCYLNSLLQTLFMTPEFRNALYKWEFEE
                # SEEDPVTSIPYQLQRLFVLLQTSKKRAIETTDVTRSFGWDSSEAWQQHDVQELCRVMFDALEQKWKQTEQADLINELYQGKLKDYVRCLECGYEGWRIDTYL
                # DIPLVIRPYGSSQAFASVEEALHAFIQPEILDGPNQYFCERCKKKCDARKGLRFLHFPYLLTLQLKRFDFDYTTMHRIKLNDRMTFPEELDMSTFIDVEDEK
                # SPQTESCTDSGAENEGSCHSDQMSNDFSNDDGVDEGICLETNSGTEKISKSGLEKNSLIYELFSVMVHSGSAAGGHYYACIKSFSDEQWYSFNDQHVSRITQ
                # EDIKKTHGGSSGSRGYYSSAFASSTNAYMLIYRLKDPARNAKFLEVDEYPEHIKNLVQKERELEEQEKRQREIERNTCKIKLFCLHPTKQVMMENKLEVHKD
                # KTLKEAVEMAYKMMDLEEVIPLDCCRLVKYDEFHDYLERSYEGEEDTPMGLLLGGVKSTYMFDLLLETRKPDQVFQSYKPGEVMVKVHVVDLKAESVAAPIT
                # VRAYLNQTVTEFKQLISKAIHLPAETMRIVLERCYNDLRLLSVSSKTLKAEGFFRSNKVFVESSETLDYQMAFADSHLWKLLDRHANTIRLFVLLPEQSPVS
                # YSKRTAYQKAGGDSGNVDDDCERVKGPVGSLKSVEAILEESTEKLKSLSLQQQQDGDNGDSSKSTETSDFENIESPLNERDSSASVDNRELEQHIQTSDPEN
                # FQSEERSDSDVNNDRSTSSVDSDILSSSHSSDTLCNADNAQIPLANGLDSHSITSSRRTKANEGKKETWDTAEEDSGTDSEYDESGKSRGEMQYMYFKAEPY
                # AADEGSGEGHKWLMVHVDKRITLAAFKQHLEPFVGVLSSHFKVFRVYASNQEFESVRLNETLSSFSDDNKITIRLGRALKKGEYRVKVYQLLVNEQEPCKFL
                # LDAVFAKGMTVRQSKEELIPQLREQCGLELSIDRFRLRKKTWKNPGTVFLDYHIYEEDINISSNWEVFLEVLDGVEKMKSMSQLAVLSRRWKPSEMKLDPFQ
                # EVVLESSSVDELREKLSEISGIPLDDIEFAKGRGTFPCDISVLDIHQDLDWNPKVSTLNVWPLYICDDGAVIFYRDKTEELMELTDEQRNELMKKESSRLQK
                # TGHRVTYSPRKEKALKIYLDGAPNKDLTQD' , 'MPSYTVTVATGSQWFAGTDDYIYLSLVGSAGCSEKHLLDKPFYNDFERGAVDSYDVTVDEELGEIQL
                # VRIEKRKYWLNDDWYLKYITLKTPHGDYIEFPCYRWITGDVEVVLRDGRAKLARDDQIHILKQHRRKELETRQKQYRWMEWNPGFPLSIDAKCHKDLPRDIQ
                # FDSEKGVDFVLNYSKAMENLFINRFMHMFQSSWNDFADFEKIFVKISNTISERVMNHWQEDLMFGYQFLNGCNPVLIRRCTELPEKLPVTTEMVECSLERQL
                # SLEQEVQQGNIFIVDFELLDGIDANKTDPCTLQFLAAPICLLYKNLANKIVPIAIQLNQIPGDENPIFLPSDAKYDWLLAKIWVRSSDFHVHQTITHLLRTH
                # LVSEVFGIAMYRQLPAVHPIFKLLVAHVRFTIAINTKAREQLICECGLFDKANATGGGGHVQMVQRAMKDLTYASLCFPEAIKARGMESKEDIPYYFYRDDG
                # LLVWEAIRTFTAEVVDIYYEGDQVVEEDPELQDFVNDVYVYGMRGRKSSGFPKSVKSREQLSEYLTVVIFTASAQHAAVNFGQYDWCSWIPNAPPTMRAPPP
                # TAKGVVTIEQIVDTLPDRGRSCWHLGAVWALSQFQENELFLGMYPEEHFIEKPVKEAMARFRKNLEAIVSVIAERNKKKQLPYYYLSPDRIPNSVAI' , '
                # MSFANTSSTFEDKMCEGNRTAMASPQLLPLVVVLSSISLVTVGLNLLVLYAVHSERKLHTVGNLYIVSLSVADLIVGAVVMPMNILYLIMTKWSLGRPLCLF
                # WLSMDYVASTASIFSVFILCIDRYRSVQQPLRYLRYRTKTRASATILGAWFFSFLWVIPILGWHHFMPPAPELREDKCETDFYNVTWFKIMTAIINFYLPTL
                # LMLWFYVKIYKAVRRHCQHRQLTNGSLPSFSELKLRSDDTKEGAKKPGRESPWGVLKRPSRDPSVGLDQKSTSEDPKMTSPTVFSQEGERETRPCFRLDIMQ
                # KQSVAEGDVRGSKANDQALSQPKMDEQSLNTCRRISETSEDQTLVDQQSFSRTTDSDTSIEPGPGRVKSRSGSNSGLDYIKITWKRLRSHSRQYVSGLHLNR
                # ERKAAKQLGFIMAAFILCWIPYFIFFMVIAFCKSCCSEPMHMFTIWLGYINSTLNPLIYPLCNENFKKTFKKILHIRS' , 'MPQASEHRLGRTREPPVNI
                # QPRVGSKLPFAPRARSKERRNPASGPNPMLRPLPPRPGLPDERLKKLELGRGRTSGPRPRGPLRADHGVPLPGSPPPTVALPLPSRTNLARSKSVSSGDLRP
                # MGIALGGHRGTGELGAALSRLALRPEPPTLRRSTSLRRLGGFPGPPTLFSIRTEPPASHGSFHMISARSSEPFYSDDKMAHHTLLLGSGHVGLRNLGNTCFL
                # NAVLQCLSSTRPLRDFCLRRDFRQEVPGGGRAQELTEAFADVIGALWHPDSCEAVNPTRFRAVFQKYVPSFSGYSQQDAQEFLKLLMERLHLEINRRGRRAP
                # PILANGPVPSPPRRGGALLEEPELSDDDRANLMWKRYLEREDSKIVDLFVGQLKSCLKCQACGYRSTTFEVFCDLSLPIPKKGFAGGKVSLRDCFNLFTKEE
                # ELESENAPVCDRCRQKTRSTKKLTVQRFPRILVLHLNRFSASRGSIKKSSVGVDFPLQRLSLGDFASDKAGSPVYQLYALCNHSGSVHYGHYTALCRCQTGW
                # HVYNDSRVSPVSENQVASSEGYVLFYQLMQEPPRCL' , 'MEQKPSKVECGSDPEENSARSPDGKRKRKNGQCSLKTSMSGYIPSYLDKDEQCVVCGDKAT
                # GYHYRCITCEGCKGFFRRTIQKNLHPTYSCKYDSCCVIDKITRNQCQLCRFKKCIAVGMAMDLVLDDSKRVAKRKLIEQNRERRRKEEMIRSLQQRPEPTPE
                # EWDLIHIATEAHRSTNAQGSHWKQRRKFLPDDIGQSPIVSMPDGDKVDLEAFSEFTKIITPAITRVVDFAKKLPMFSELPCEDQIILLKGCCMEIMSLRAAV
                # RYDPESDTLTLSGEMAVKREQLKNGGLGVVSDAIFELGKSLSAFNLDDTEVALLQAVLLMSTDRSGLLCVDKIEKSQEAYLLAFEHYVNHRKHNIPHFWPKL
                # LMKEREVQSSILYKGAAAEGRPGGSLGVHPEGQQLLGMHVVQGPQVRQLEQQLGEAGSLQGPVLQHQSPKSPQQRLLELLHRSGILHARAVCGEDDSSEADS
                # PSSSEEEPEVCEDLAGNAASP' , 'MQVPSPSVREAASMYGTAVAVFLVILVAALQGSAPAESPFPFHIPLDPEGTLELSWNISYAQETIYFQLLVRELKA
                # GVLFGMSDRGELENADLVVLWTDRDGAYFGDAWSDQKGQVHLDSQQDYQLLRAQRTPEGLYLLFKRPFGTCDPNDYLIEDGTVHLVYGFLEEPLRSLESINT
                # SGLHTGLQRVQLLKPSIPKPALPADTRTMEIRAPDVLIPGQQTTYWCYVTELPDGFPRHHIVMYEPIVTEGNEALVHHMEVFQCAAEFETIPHFSGPCDSKM
                # KPQRLNFCRHVLAAWALGAKAFYYPEEAGLAFGGPGSSRFLRLEVHYHNPLVITGRRDSSGIRLYYTAALRRFDAGIMELGLAYTPVMAIPPQETAFVLTGY
                # CTDKCTQLALPASGIHIFASQLHTHLTGRKVVTVLARDGRETEIVNRDNHYSPHFQEIRMLKKVVSVQPGDVLITSCTYNTEDRRLATVGGFGILEEMCVNY
                # VHYYPQTQLELCKSAVDPGFLHKYFRLVNRFNSEEVCTCPQASVPEQFASVPWNSFNREVLKALYGFAPISMHCNRSSAVRFQGEWNRQPLPEIVSRLEEPT
                # PHCPASQAQSPAGPTVLNISGGKG' , 'MTAELQQDDAAGAADGHGSSCQMLLNQLREITGIQDPSFLHEALKASNGDITQAVSLLTDERVKEPSQDTVAT
                # EPSEVEGSAANKEVLAKVIDLTHDNKDDLQAAIALSLLESPKIQADGRDLNRMHEATSAETKRSKRKRCEVWGENPNPNDWRRVDGWPVGLKNVGNTCWFSA
                # VIQSLFQLPEFRRLVLSYSLPQNVLENCRSHTEKRNIMFMQELQYLFALMMGSNRKFVDPSAALDLLKGAFRSSEEQQQDVSEFTHKLLDWLEDAFQLAVNV
                # NSPRNKSENPMVQLFYGTFLTEGVREGKPFCNNETFGQYPLQVNGYRNLDECLEGAMVEGDVELLPSDHSVKYGQERWFTKLPPVLTFELSRFEFNQSLGQP
                # EKIHNKLEFPQIIYMDRYMYRSKELIRNKRECIRKLKEEIKILQQKLERYVKYGSGPARFPLPDMLKYVIEFASTKPASESCPPESDTHMTLPLSSVHCSVS
                # DQTSKESTSTESSSQDVESTFSSPEDSLPKSKPLTSSRSSMEMPSQPAPRTVTDEEINFVKTCLQRWRSEIEQDIQDLKTCIASTTQTIEQMYCDPLLRQVP
                # YRLHAVLVHEGQANAGHYWAYIYNQPRQSWLKYNDISVTESSWEEVERDSYGGLRNVSAYCLMYINDKLPYFNAEAAPTESDQMSEVEALSVELKHYIQEDN
                # WRFEQEVEEWEEEQSCKIPQMESSTNSSSQDYSTSQEPSVASSHGVRCLSSEHAVIVKEQTAQAIANTARAYEKSGVEAALSEVMLSPAMQGVILAIAKARQ
                # TFDRDGSEAGLIKAFHEEYSRLYQLAKETPTSHSDPRLQHVLVYFFQNEAPKRVVERTLLEQFADKNLSYDERSISIMKVAQAKLKEIGPDDMNMEEYKKWH
                # EDYSLFRKVSVYLLTGLELYQKGKYQEALSYLVYAYQSNAALLMKGPRRGVKESVIALYRRKCLLELNAKAASLFETNDDHSVTEGINVMNELIIPCIHLII
                # NNDISKDDLDAIEVMRNHWCSYLGQDIAENLQLCLGEFLPRLLDPSAEIIVLKEPPTIRPNSPYDLCSRFAAVMESIQGVSTVTVK' , 'MNTSAPPAVSP
                # NITVLAPGKGPWQVAFIGITTGLLSLATVTGNLLVLISFKVNTELKTVNNYFLLSLACADLIIGTFSMNLYTTYLLMGHWALGTLACDLWLALDYVASNASV
                # MNLLLISFDRYFSVTRPLSYRAKRTPRRAALMIGLAWLVSFVLWAPAILFWQYLVGERTVLAGQCYIQFLSQPIITFGTAMAAFYLPVTVMCTLYWRIYRET
                # ENRARELAALQGSETPGKGGGSSSSSERSQPGAEGSPETPPGRCCRCCRAPRLLQAYSWKEEEEEDEGSMESLTSSEGEEPGSEVVIKMPMVDPEAQAPTKQ
                # PPRSSPNTVKRPTKKGRDRAGKGQKPRGKEQLAKRKTFSLVKEKKAARTLSAILLAFILTWTPYNIMVLVSTFCKDCVPETLWELGYWLCYVNSTINPMCYA
                # LCNKAFRDTFRLLLLCRWDKRRWRKIPKRPGSVHRTPSRQC'
                'target_component_synonyms': 
                {
                    'properties': 
                    {
                        'component_synonym': 'TEXT',
                        # EXAMPLES:
                        # '7.6.2.2' , '3.4.21.59' , '3.4.19.12' , '1.13.11.34' , 'H1R' , '3.4.19.12' , 'c-erbA-1' , '1.1
                        # 4.17.1' , '3.4.19.12' , 'CHRM1'
                        'syn_type': 'TEXT',
                        # EXAMPLES:
                        # 'EC_NUMBER' , 'EC_NUMBER' , 'EC_NUMBER' , 'EC_NUMBER' , 'UNIPROT' , 'EC_NUMBER' , 'UNIPROT' , 
                        # 'EC_NUMBER' , 'EC_NUMBER' , 'GENE_SYMBOL'
                    }
                },
                'target_component_xrefs': 
                {
                    'properties': 
                    {
                        'xref_id': 'TEXT',
                        # EXAMPLES:
                        # 'ENSG00000103222' , 'GO:0005576' , 'ENSG00000170242' , 'ALOX5' , 'GO:0005886' , 'ENSG000001432
                        # 58' , 'THRA' , 'GO:0005615' , 'ENSG00000048028' , 'ENSG00000168539'
                        'xref_name': 'TEXT',
                        # EXAMPLES:
                        # 'plasma membrane' , 'extracellular region' , 'nucleoplasm' , 'Asthma, diminished response to a
                        # ntileukotriene treatment in' , 'plasma membrane' , 'nucleus' , 'Hypothyroidism, congenital, no
                        # ngoitrous, 6' , 'extracellular space' , 'nucleus' , 'plasma membrane'
                        'xref_src_db': 'TEXT',
                        # EXAMPLES:
                        # 'EnsemblGene' , 'GoComponent' , 'EnsemblGene' , 'CGD' , 'GoComponent' , 'EnsemblGene' , 'CGD' 
                        # , 'GoComponent' , 'EnsemblGene' , 'EnsemblGene'
                    }
                },
                'targets': 
                {
                    'properties': 
                    {
                        'target_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL3004' , 'CHEMBL4700' , 'CHEMBL2157851' , 'CHEMBL215' , 'CHEMBL4701' , 'CHEMBL2157852' ,
                        #  'CHEMBL1860' , 'CHEMBL4702' , 'CHEMBL2157853' , 'CHEMBL216'
                    }
                },
                'tax_id': 'NUMERIC',
                # EXAMPLES:
                # '9606' , '9615' , '9606' , '9606' , '10116' , '9606' , '9606' , '9913' , '9606' , '9606'
            }
        }
    }
