ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground-unstable.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1-unstable.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� o�AY �=M��Hv��dw���A'@�9����������IQ����4��*I�(RMR�Ԇ�9$��K~A.An{\9�Kr�=�C.9� �")�>[�a�=c=ÖT����{�^�WU,��͠bt{��=M5M��׃}ݲ�C����N@!�F#������'&��a���l��c(����@ݍ��������m��Z����
hZ�����c���9Ph� ��0��w�K�eU��.w�ޤ֭T�r��F=hj�ބ&9��R{�!���my}��T����<vˠ>PMC�B�#	�X���3��OfR{�[��A�Æ��l��u���ኦ�P5���֐k����n�̣Zw�O0�r��a������RL��I`����@�mt�Zlg#D���X݁�CY�؆�b�-�'�'C��D(A�EX�\�B�o��a�Z�5�:4��@�/���E>Ӯoj����S�H��%�r���	bn/F�T`I�7se�xRZ2Ҕ�w4���յz��)�MZ�1�q�j˶{�UE��2��R��Ձ7���-�e��>��rnJh�'*d ��9Z��� ��u�	_K�Ī�7��c�:����������]յ�|�zP�ʒ�X�q�M��c������#phCS���W�ugg>.���SN�A���&�:<��b���x���,���� �[�d	|�����P6놣s��p�ÐպW��J��h/��OGY��������o��K���dM�Z��\%}���ݒm�Q5�z��k *���뺪7/�B��4B�F��S�5A��GO��=ϟj��G���� �r��sܥ��1TZd=ܷ��.�	 ��- р%���a��Qp�t{&*"�����3+���C��_���n� ��t�`)&'4���F��-�@��Db�+��%�>6�̯ge��y��UL���)�����>�g�S��	COt�md6`I�ǉ�O�O~�4
�s��е�+�)����Y���.��K3�:�����.��+�U�m�y����n!Ay8D��5([XPC� pZ�����oA��Z�O�
���a��:_�L,��;�@ձ��^~��M�9b�˪0�G.�$v�'��5�� �L(w�?�D��<A�D�|���C��ˡ%+D����la���xy�|׉߇5�?E3�;��Y:�PQ�E�Xx;�o����
D��	P��G]5qz����*��� ���O૯@ϩ�o��zq��u#?(Xb��������%�[��l��Æ+���j��m������K�ٴ�f����45��"���7o�����Ly���^�x�X�@0�3aC�f��7��A�d�u�K�_1�l��*��#~Op����b��3���?lXb���|K4��?2����Oo��̀�G���=|��ۙ�N+��a�]m~�oŘ���d�!H�r�۠�&�y�؆9"n	Tә�YE(g����o�~3*𽿫S�w?z=���1f��(^�G��_�g�b��)��\n��^3@�@_����-�����W�������,j\�'�o>~4[���;���V�\�zV�Hbᠺ���e��,xbA����t�fZ�Ӭ�xOȄ����%�}��{1�%x�<ZJx����	��W`��n,�du��@�wk��o�b��[R��m�L�<�@g|�N�D��yC�"���fGQ�ÙĖ��9yݝ����Ĩ�=��	X����i���}�{��n�OS��_����.������s��F�m��	�;�%�Y���lZ6��i�߀�����;���(�x������K�֑ ����������$��ZWm�lP�0�bX��X�pi���䵅�̋/ �X�!gq��0�	�Stp]��˦�:��E"s�?�m�6����d�žЖ�n��l��q����#�����H��ƯD��ѳh$H���A[^�J�o�F������fnA��+�zmIë�]��˦���
/��v�g#p�ݴ�צp�5�l��7Xמ�����q����1_�ɩ�ɚ��8>@^�xhvA�l�����{��/{�[��my�.��{��S�zlŨC0s<!L�^yv�}s,,��� E���c�f�pS�~�w�C������&�l��6������/w���\w}˶���s:�:���@m��А������g��ɛL8�5'r�yb��\��3M61%o��[o�c�V��� 쭬E�	�澧.���q\	�PA*�Pϊ�X>�.'U�����U�9T佌_��}�
9�v�ٷ�Sq_��n�U� X���[<fx@� ��&AL^ǚ]�;�i�	Z�"y�0T}H�Sr
�A���k���PT���
��В����b!��17_��c�c���������4�������P1�����m�����xM}��?���w�����&��;:�ި��#��Q\&�Z��219V�h��#tXi�J�m(T-J)qV�l<�� �wh�;��ү��6}�/������E�/>y�ۏ���f�W�1qIt������i�"�li狝�?En�A>t���v|�B��-4y�������W\�xY��?~���v9����~f(� ~�zak��?���b���Q�O�L������>��lR���������{��;Ab"�����?�����~�~��/�?O:�T�dx�O;�YjS���	���B�7���i-�5�����l8���&`��O���0k�=OW����@�q
�]�;K$q1�t��%+b�_ŝ�9��,��.�
�}�[}���|X->>���� �JB���b\9�*���|��]�z��u؁���'3L]n��h����e�̆a�mD�E��kв�����.S�5j�ݨ�ġ�D�3��#C�
�=�"��xwm�߅S�
��9��Ƙ:�2��u��u����L�]�i�_(6�A��,�_�t	��z�}�-�b�����\����x(����o�F�T�b�K$�b��O��?+��g%S��j����Cdj2�[b@�t�v�*+Ԅ:�T�OV?�T�J�X������/e�|J��ꪹH�g�M�'�-�2��ڭ~�G�ʚ�fb�Ӆs��3B7-\6���8T��A����!L���ʴe��-!9/�[۞{�؊۾V��{�oJ���0s}�6���-���k�|�n�Jw��C�L�'��L������I�-òɁl�f_�C��5mI��>��+x��"����Sn�9��i.�
�KL��$D� ������k�B`��%M�슻��V��n�04�p�m���3�5��1}����c!eO����8�en�����),|���Ԅc�|��s���~s����DAȢ�K*UO4gy�zT(g%$���k�fu(&R�m��UE��W�x�"�x76�_�/�t������Ro治�����t׋t,�qx�K��㹚�o��i楎��ִ[v�\�j'F�7kC���ݍ��>��s�j��5�K��^��P�=� ƽ��	+.au+���+O,�1q��n��L�g���o�t�=�j�Fd�U�3���X�����Y������FX�ޮ�n��E���ƍ��З��7o]���m�S��7!2D~�3�fN�;�������O���f����> �w����o�}޺�(�{�����~�-��M���?��������Qf��3[��	،�w7���;���p��������a�y��Ƣ[��	ظ�_~�ur<�}��C�M��+����|Y����_� ^Le�@��L2#pU�-%�LFȶ�������f��9,EӃC�E�>?eO��K�.�,�l��:�B�TJpmޑJ�C���a����bUB�8�@x)[b��|t:P�l�*I|ɭ�R��I�3��89b��q�]�O%^���R-�B�*�SI[I�\7?�U/q���C,"q0�P��GI��Pjs�|�TFe#����IIkH���?乓*�V����ceD��89�N���ZWkI�'ɹuiѡ�'G�&Q�_�j�|Oa��w�^�D�?�OSt����a�{99��Z����R���I�����6%p����=���D�ɉ�~�RKv��y����s\Ig�����d&�D�0"�&���y�QH=�F.��#�j�§�ʅ 4ب��亃��W��$���2U$�R��9���QS�%,���RI�8#%V�+$��y�s�:�y�)	�9Y�$A�^ڼPr2�4Tf�?���iX�j��1S�_��q�0j�V�T
F�p����zf��D��2�i���5���R����q�^���)-I�*�F<q�j��y�GQB&�V��r�أ�����ճ��X�����RT����Ekxߖ�n�>�tt!��R�6��l&��'Է��}�m��a����3����6��l��o���!�g����n��M�����@�?����2WԳ�J�q������n��Y�D��j~��(	1GH\���[�px(���%�ͪ�ɷj)�����|$�m���S��CT��)B���.N��0U�=�*�vG�b���ժ��i�m�j
Grq�%HN��䥪����T�8R��9�em�̙��y���wY� �:�]�1��H�)����y�"Ev���2q��#�9*��9�Gh��j*����\�YL��r�ivӕ~NIV�H�Įu�
��܈�4�n{H���n����C�V�jd�������\�u����~������^�;��OWD�͕�f���4����K
> _t���5�"_�x�A:^�͒�����<:7��9q�,�8\����\��Y6W{Fj��LT��s�O�|�K�IN93�;N�q�v�煃a3��2��������g�j9�~a�E!#4衚hf�O�&'��� kV��i�a�n)*��s>7���B�}���;����m���L������~�6�������:�������l��Ͽ#�5k��>�>��Բ������5�?_��9����|�\����,qq/eu���:Ԕ��}O�m��3뎓o����w&�j+���WԜ���fP�T�@B�z�I�z�h��wps�����GR��/�`�a�^�W�+?�m����J��R����8Z����n������j��s/�A1��cv��v�q�d��-ӻ���pf�*�x��qDl���)|0�.6����[V��yu˱M��^)��8���=2P���2�疾�OE1T�\�1X몡����`M����?}H�6CC��_��g?5��*�x�"2$��P\i4<�Hf�+e���t�d#c�G;�=�|?�ÝC+㍱@��c�{��~XQWQ#ă>U��n̹W���dG��5�+	��]l-�F�Q���?4�M�x�ݟNх��?����@��?���_����L�?��k�w��C�h�O~C��k����$Z�e�$1��>�
�t�$!�'�x׿��U=�)�Pŉۮ��8��kj�����"o�`�)�������M��泾���D>�v�o�l��������ٿ��Cg��ܨ��H&����L�+I��e0�nƪ��_�O��mVV��W׌�_���L�҈'c_���m"��Y�)pa��х��`��������������������O���?�?M��'�'�
��	������n��x@�A�[��I��6B����n��:o�s���������Գ��4BW�?KR!��,&x�bȔIi�c�,f2��8��N(�'�<"<fcNb�f�4"R�?�����{���X��3��k�o�3k�!G����_�����Λ��u���f�;���ݪw��Dn��9����d�`���N��o�;/ը��H�k;�ݏ��0����Ȫ��jE�!ߺ��"PTAݷ�mi�j�vu��{���~�.�{�)busǺ����z�����;F���^�?��&hy��`�������=:��������o����G��)�_@�;�C�;�C�/�-��2��?v��	�6���F��? ��;��Ͼ>����o�������T�3�c<�W�D���6��G)����������䆈ݢ�?�-��{�wϼJ^�n��q>^{5 �}c��㱆o�B�u���b�˂�I�݊\o<���>�ǅe&jϿ��C�;�yܭ�eX��׈워��NF�׌Y����m���m�*2���}9�2$����p����ΕC¦opW������:]��_)�^���XS�~�'����ܯrQ�땢R��݀
�<m��9*��ܫ�����L.z�6�X�9~G�>�����=��KF�>��N����-��2��?v��	����[tD����D����O
��?!��?!����'�}]���o��_���}wi�����s��������hD�#�L��bؘ����2�*���e�$�r"�r"�Șz�!�i�ǹ�F4�g�Fp�����?;�M��#������=5_��@�|K��l.�-�$U���؏��^�u�/�m���&������
��޼��1Ұ~X��r,����:���8���|��\>X�����enx+�b��W��~+]X�	������7B#�?��w������'HX�� ��a���a�����}�����.M|�?���P���]����=����g�U�,m��ߺ����Ѳ���-��߶��������(�r�#^���}�A1)��<�$yLN���,��t�I�-�Q��]��g�?,�4¯��Y���K�Fa��[	�lA��ڮ�9���W���T_~���<�P�Ux��t<_m��6��~O���C��h�.K;���t3�.jiq�z+�j��Kb�c�)��m��͡`��ta���ڣ���h�.����ڣ�O?���i���?��AS������	`��?a��?����Z����������N�?�?�Fg����	��t��?������F�����p�I��S���~ �7���y�C]�^0Y'� ���W?O�����>m���S�t��s�]ђ:Z�X�O�r���+׎�����h��Ԙ�8�cO�j�R�G�"G˹��fY�����qh�-L��iO�w�M&ܒ^���ͬ�su������th��)���^%Mu�h�1I��o!�?6���_�?����-Z����������N�?������-�������?����������=�?�������c�����h����?Z���m�������8I�,G$Y��1IG9�E�3OPl��4�Si�Ƃ@���4O�T��IL�d&@������������6>���#F�%u}���b|���.�D:�4�����aNiB;��BV'ҝ�e1%U�_n�9�b=c�d���>*��JԱx�%�ˡr&Ye��eo�36FZ[դy�����.�����-�����2]X����G'��?Z�;�#@m �?[�a��`�� ���?��h������C�GktF��? � �L�?͐������������~����3����j3b?gB=_0����b���_���7c��q~<��~e��N�7���(�m�̣��n�_C�f�WL�#��B蠵��Q+���H�+9���|#���zaXa=@�~m�Ԅ�t�Y[mo&UBN.����ϿY�Ź8W�*^�/�Aro<:�:V�sH
'c���:b_vU$d����b��,�"�'v<X��}��ռ�{�����l0��H�У%� �[7�u�ߎ9�u����K׭��ԾKRΰ�d5�\�h�4TT������g�Þ��������i��9�*2���7.���k��=�@���P�^��R��z�C�nI^&�q�'2�]�ʀ���e���0]�m�a��=�mvl*a_v�d�F��FE����~�CSŷ�2�R�Suu= 8{��r�\�>�p\Ɍ���9���E�N�T��µ\�v��|��ʗ�E��\����7Ӊ��?Z����?Z��Ǯ�:��������-�������?�����q�����_"~���p��&�B�O������7�����+���,M|�?��C��7B'��}5���$�4��p̯��������$�$���q���@�~hJ�x��_�G��PY�����q>/h�R�[��[�e���C������_|O�"��|"�b�����Lw>���^�1��\6�=�.)�}ٵ���ާ�E�����}�Z��F�~;]��{��Y+{��vKj�"�V�Z7?�zPʞj�$�^��>���b�y�i�WaJ�S�ӑ��>8U5�oD�3�G�H�̛dA6Y_���:;ۘ�C[Sp���8�'�25��.��o�������h���c~]��Ǯ����p��=��0�ݢ���������u���ߔ����Ȝ�"�a'��N�s���-������?lc`�z�����@�1����voq���܋�͌;9Y���Ie:7���\8�}^���^E�Y�hל��6��;�M�|���&��D�����<\��=�SuM�yI8��h�k>���	%į���H��`��Ml���{����O�t��e�����p��q;=�"+Q�*����l�z�"�e����A�j�4�_m���%�]��^�����Fh���c~]��Ǯ����p��=��p�]������������o��C�C[����x�Wi����O�����O�O�?���M���g���� ���ߺ�O�A�C#���������Q��o[�)����p�����<�pD�R�34�	�r��S88%���T���D���YF�9N�9'��9�׿�ߛ.�?����?����y�Q��+����:D�"~��$�x=z��Y������"<��JZ`�@��v8���+�M��@�i�ma����N�9���p�z����ro2߫�aG�3���٥�;��q0��|'�k d�k�`o����9����(F��ٝy�����;F���^�?��&hy��`�������=:�����Ew���ڠ)����'������O���O���_�C����]�uB����C��:��� ���t�������������q�c�s��r
�=�ɗ�^LhA:����������[~�z�D���ľ{�sP��	�aNM��j_�Ɍ&6�]�C�l���M�E��0)b6%.r��O{_�����j�X-�Gxe���]��X|=�}s�s��������y��ۣ�ƷG;Q��!U��jseH:z�<&�ٯ.#,�x"��(p��f�bXV9��A��r��y�a�b����J/����Ȕ��L�|��3im�}��C]�1��Ws��;����L�Q��YFS.�{�^_]F4q��1���k.X=B��#�"�|�m�v��N����-��2��?v��	����[tD����D����'������O���O��?�����#����D��K������]����G#�O�t�0x�	q.d\���9#�DĤ4���]Iw�Z���~E�Y�C}3��:D#	$����R��~}A�8�J�X�+>{��Ċc{߽�9w����#��#��Y��"&b���4f���a@����&`��������i�;'v_�Y^��ԽБG�mᒭ.���P�f�)y��m��JT��k��M�4r3���z��8lBm��2&�x�CU9l&�ߔ�g���/����=�iV���(��0w���V�p������������Ȣ��������@���P���?� ��1�����袎��w����(�?�hu���t8��?����C����?�����*��O�q&i�
!�$L�3#��PMEt�q���I��t¥��|#B��������O����.�p��W�#��bݓ�N����&=_!L�X,��z����Ϙ2O��?KK���c��I�+�˵�%���Ck���l�c{�o��@0B��wC�p�mJ�Dײ��p����
����>�a�C�@�����������O-@��aH�	�����d8�u �?a��?a��?��k@�������s�?$��2��
����G�_`�#�������?��k@�������s�?$��?4D�|C@��C��9@�������?����H�7��J@�r ��������a��������4�C�Gs@���D`C�	�( (6%�4ey2���R&�I!�<�8�	!p: �0ao[�*% �����C�Gs����x#�3a%���l+bmƘ�Nyz�I�Yw�C>j{e�����<��;�DF�B�$��sP}߉�T��Xs2�&<%n�ɒ�{��%�/:{{����谊�Z���Q:<	s��x+P8�!��94|�C�G�@��������h��?� 5������?0��?0��������0��n���C�Gc@��? E�
��f���/���2���}��>����ΐ�Kt��akc����[�nD�gc�/�?��[�q4}3OC�zji���4uuۓ�]l4�	nF^vV���I0$��<�<X{����cn������� ���\ߣm��ɞ7O�z�.GSϸ��s�����jd��K9��:��dK\�&6��_y���Mr>�3Z���87s�4*���a��篱�o��?C���?��ϭ�����h��?��������s��?�����y�����7�8��x���_��E������������������m�7^�&���(����������K^����i�����P3�?�@C����?�����?q4�Ղ_���,���U�׍��,җ�'�.�����?]��(���+�?K�V�fσUju��V����?���~g����f؛J��|u��|zs9���;��]���9���9����J�d6��t���æ<�i��޵�)_��x�'^81���[�D1k�q�<^��p ���Kكrng�������s����e\�uW�EѸ͂]�I��
C�������.v:,ۗ�d��,��Z�?�x�7ɇ^�2�j�����dϟ�t}W"��j�=��1q�PYkqR�{5�:m6��\%����.�P�<M��BdGF����?�"�RDn��17��tOS��w�[ioɛ���z=
�����?�ZP�������ϭ�P����_��0��	�����?ׂ_������7�ߓ���4[�x�;��9t�������>����e�kbH���^���j�XcR��6��osN�$U_Tr�����|�ϷG�,�|JY��\���HM�b���S;\����Ƙ����N~���~��Q�`V��Њ�imȢ�]������Q��-�J��\[JR�RE_��^���K�5銕Z)՗gƷ�.L'�x�,\�헢�E������,z�FN�#�b'<���e������"���?~�}��3zv���q��.p�����?v��8�MC�6��R�mnCa�RZ����L���;������[��>`6;򒶲�g�����go����_����.y����[������ou���%�ò�2@�@���̃�?	�����K���ۃg�_]���zQmC�mlU�"�]Fŗ�W�?���λ2�Ee�j���8���r�j�_��W.�+l������[�;�I�5y:w�����]�l�˙#�"jۖ{�7�dj�YѺ���Q���>Ŋ����z�H�>��A�f��d�=��*�n.}��_�Mz���<�,Z�s���%�W;��4�r�h��Rl`k���^���� �)|��g_��ط�x&�D�u�����e���\>%=c�aR�|?j�͘V��1	q�����N'̮��NR���������ʚ���I�g�OQ�������������_����A(�?��4��@��?��iV�=�����ZД���@A���������������N�J�T�~�t�l�_b�"�UE��轖r�"�����V/u@�u��<]?0a��X����<l)��M��9?�[^�+��IF��m��}�"�`�<b��m�I��vtr���	�U��N/.�;��nP�v�I���7�v���er���]���G�b�c^ꀖ��f�c�ϧ�S�F��KF/�[2����&�.�Q��zِ>�[�S�3�����f��3؏��!��2�����u�h�?�4�����|��߃�O�f@�Ձ_������z�uh�Zf�n�+v�*����O�-��w����%���7�`}�P4��V�����+w���H�*;��U�9���(�~VW�tN�♤Sb����Y�q��rT�Ñ���Ց�)/�'��n�2����t�t�qz�-Jv��a����=v���DE��z�{^�e��S����u+) �E�җlA�z��V���W垜���]M�`/s|('aY�U�PX��h8ݕ6;I�x�o�H�?��k��?(6���5���{W��'�o���S%j�Q��ڋ�X#E	0���C�.Ã,��(�7�S�_O�m��$j�v�����*3��qIu�����FX���~�r�l��ֺ-a�rМ�_Ӊپ�����w�����Qk�;g�$���B����HͶ� �.�3]�p#V[��d���mkkG�8%��)J�)�FhꞼ�]��\a9�*p���ـ����_ch��h�Ɓ����_s��?M��`���i(�� ��!|���� �? �:^������+'@�C@�����������o�[��' ��o��I�A�;	�_��"9���>���1 ��7��ԣ�/��� �O��N� �R"I�X �gSBH6	�و#қ.�yF XR҈�X>NȘ��-?�{�o
�O����0�U^��Fv���T�k�O늙*���$ix�z�����ޝ��U}J1�?k��G��-�ur(ҮVr���x��G簛.���5���&�)<K73i�#,��Z�N��w�^�3ӣy�E�~�ՏB�]+3yN�}{�-fv���0��ug�>�������$�1p�ׁF�X�8P8���5$���������
��b�fP��o����9�u�W������H�?�����]���q�����	����o���������B�������/��ւ_����������KFi���Y��KעI+����q�_U���d�g��~�:E�V~��(�����A����D�2V'�q�M+��)+��e5k�ztN������D�}η��3�#��i���TÏۊ�6�\��������<]v����JɾĘ�n�1%�v���nU	�����e<[��Ƿ&���I�^g�Ȇ(V���$[Uo#~Y�e���V<`�(e����v+傛����eZ��;��mf�˻[�P>�Qϝ�P�[%�G̾������+�KO��4�5�����n�f���������Ш���������H�?���?���H�?��ƀ�������.��G���?��Ǐ��(h����?Ő,��:���'�����Ԅ~�A�#�:^����������x��������I?���O����?�p���X��(�<��XHɈ�0dٔ�I�棄����;!J ��Q��{_��U��������0��I�Vχ�q�����aW
��O_6q���^m�Lgy|����|�n��w���(��ģ��?j�G�����w�Q�����?���?B����sw�O��Q����t8�?���O��A�ׂ����� �?���O���4���?I���c�x6%)�e�����wE��A&q�qi"�QD2Wj�����*��п
��(�����Z�'�?�E�s�	~�$��D��l��o!:��ro�u�q�Bq�N���"	���+�2֍���:��,j9��kL&)vѣ�@���e�W,1Iݶ>Z���rE(�`1[nO�LK�q�,��Ι	��������`�KMh����w4�����9 ��ԃ�O����?�iu��{�30�W������p��Y����_MhJ�A�; �����O=��B�{-h��a�[�@��?��v}���o��������W@B�������ZД���w4 ��s�?$��|����g-h����7$�?�����������7���f���ɒuR.����M���s�'���k�q$;���f��v{3�K*�efٞn��v�n2�*W�^�T���Ѩ\�캹�|�@A�
!�X�K)J�"H�!$�xG��<�S�����힞�e}FӶ��Oչ��������	��5��Qtk������W�r�_��7_���������_~���w��q�����֥o��+C?.C?,Cc�Ýn�����?~������5Wv\�-��*}�6Qâ�J�X�PE�(BH�#� *5�f4�BxDc�l�#Ѡ° *�Mx~����7������?��o���{���z����1�#�g�'��;�kq�f����u��m��oC����qR ��m�;oC� �e�"��o���[Ћ���|�ɛ���yR���/�A��A?������6�Znʑ$��w���'��I��-p�N�ƍ	�_�fJ�C4L��<Ë�<�3|z�t�X���L�˼9����&�a�R��<���V�d�%,���@��V���Y�uy���X���Ƹ^w�Z�Ӝ��g��L	��`��:6.i 6���m8_��sj8BmH��d"�+|Nj��`[Ö���9a�8�b`L�N�lg�1RP�3��*Kb!�B�):J���YK`{�'�s��!S���4�!Jd���К��j@'y�����wgl�T2WsB�=�����~^i&����z��gù�_�i\:S�\?��oͧ	�L*M��\=^ǚP/���
�Q+5$,˫�I�dc�`��Y��1�t<WБJ���F�&�v���N�>T�AH2�d �"����� 	��%RE6=�b�3�����	�'4��#�i1Y���%��kw����)��y�qs�����!ԨVƼ�U�\��(�菋��bU�Ob	e�
�b\Ak��X�!vr����p����`���܈����ׂ�6G'�.FW�ZBK�N�C.���I�i��{L'J��3m�@�u:�(M�%eE��P�r��5Br�ϐх��ΐ�N|�v�m�N�--����4�O����(���N?ذ��fM�5r�D��'u!�:a�� �+Y�(��#94�
������q�����u(<��E���g�	1�&KN��˃q��h�sxO��&4G�|W���ʤ�V�a<X��D#EW�~|�Pc$Q:Z+m=KVs�v@�<�-7�����՘�(iLũi�$CW�
�e/U�Њg�e���#�%e�
���,>Iĝ��f��`��N4���)��9�i�Y��V�RVpDfP���j-�FeXU
�ηG�bŉ�E����R��v�}kr�ץt���#SD{�p=��Á�dm�@��t��p��y4�Y��������}�=,���e�茳�>���@=�sh� ��s̩~�k&�d�ה��2ָT�:YCLNdj�R�C�J(N�d�(�Hu(��\�˓�Q5�N�ln�+a\�ws� N�c�d~�s̡Ճ�M�N����;5��R��`���a�AX�rS7���ث�`���V��eͬ��R2`Hj-"�d6�%��U�T]�bb�i�4�2[*Z� t5)��F����d�z5h��@�?�@X�7�����/{����Sk��@�Tm�[>���_�y~ށ_������k�K�xY����;�/�/�T؅_[V�v'7aeA��&,n�oL�0O?��{�ޝ)����܅�h���r坝�)�`0���2?���m�x&:��M(��M��3Dϛ�n���!� I)���� �tb�}�+�ԉ4�J�ҋ��;�^5oqh6Rd�Rk�
�W�%{b	|?�	�K�z��t>��c�R-aw�;��+�"�ܗ���A�*%54�itP��������Hq��X���;�٫jf��s��O��2�J�U%=��5��um�]N	�Q��-�C���ZU��*-%8�\�h�aU���&���L�o����X��J�t���L��T��LH�P�b/a�Ğ!zN!v�X��M�rK��*}�rtM���%J�Fc�W�&)=Y�Jt��P���T����g���(�j��*��,tzFAe�&Ĳ]�B��~��2�D֒�q�+��dj#�ͬ���P���bԪK!�)T��P/�T���\�
&�c��&(����(U�rM�k#�,K��12�e� ]�eCd1���M2õROb��B,����{~��x[0Y����yW45U�o����,ڲ^q����]|���l���4��������;3�������ߺs��;�.1[������>�k/������gV��^����p���m�2�M�h`���D. /V��٢� 4,������r��O��~,�o`��x��O�G\��H5if��$Vݒ^E���9,w�8+�*J�7�:4���&�`����$^��A�b���S�hۑG,ß��̉ϣ��>�<����z�Eq,?Y\w�Xky����2̶r�z�mJФQT��B� �.���;��m�YA�Pr,��E�_�;u*KP~�~!�l��~���sl�[?ǧ�ϱ�V=�%xk���Vm��[�����o\�o�^�Q��Ψ�G�2�'V���/� �X߀__��VZ�?7��-M��YZ4	���E���V�iD�� ����=#(N��ǖ߂_�^rL�\���WI�ۜ:��7��v�[}�}���>BV.����Wu������@���}i+��N�mxw�E�;�X�Y�ϒf��B��w�7 	��}�K��ϓ�s�AS��!���[�m���j��e��Þ�����@_�^�\a^�s�����������/ɣЭ���dˎ#;�{���<T�p%:�(��`l0��A؁>3��iM��#KW۽r�'��m����!���y�����J�)�� �IxeYj6���e�5�B⢈��@PR�f,�dWBQ*�"6Q	�cV�����M�����$�3���Z�'�y�������Vv��2�KǗ'��B��L�I�]h�,��,ݻ��r��z˞�������y�����7������Y�}�������-��DZ�����v � �r�U�'��@*WC�]�6[�~4�縎$�"��Ղ"������R!�f�j��,+7�)�EK���w�p���i��JsݓX1�#'��``[|^�y�g9C�sL:�7��Q�~k��g n������_�=�������Ǽ������pl���Hz�3]���3���K�@�<4�ئ&;�#��iw}����:53"P*�\�e��d��z����{�j�����c@r]�B]^�o�b�}�[��yo�RU\��x�����i86�6x|�Ղ@/��pl\7r�ظn��q���c㺑��u�������t	��>�uj��N��� 9>���	 @>tڛ����,��p���c�Hx��7���������!�]��.b��ڎ�ȶm�w�W7\D�4h��`H�!��.r @��-4�-#b߶�"�jˢk�c�J��|ｏ��}�O� ������l��0�Շ>�W|��ۈ5��7�u��V���.�N�<u�X3�[��+�mE<����_%�}�i�h7���I�S`=A��˜�ԩ�Ղ�.h(r`��$Z^�A�����R{��J" j�ȼ��wyw!�� _�2Bȯm8B'%��4���[@-B|S"��Y��M�=��iH_��|�mٖx��k�(hm�q�.|�pJ���5DԞW���z���.2W==�է|��&�T;��oS[����Wfs�G4mѭey ���
Aߒ�t�V8ī�ރT�����b��3(�>^����:My%K�z>�GI��` ��B`�!Yl��/f��d�8h�/�iҔec�m�����Wk%��:2@����g���t���xS����`*���L�?[���O��?`pk�E��2]6�A,�6�پ��F�u��B`����U��Sp��zr� 3��.9����ָw����K���LA��p��G�5������Hz������B�猪i��U�x�y�/�Ae�'�Z�^h�gD<Oy�$#�.���y�˫�>!]�G:�<E��x� p4�E-�VW��r���_�6�WloԞ�����(����Hϫ���p��;�鵩�䀝�+�`��.�;��#�8�7�n���;���� �9DDMP�ʺ9P��j"�T��~,vk�f/�q���ܬ�lj��dE�k��)C�I�s 83�W����ؔ�.���!<�.������?���zL�=� dnG�!�	 �L�u��f��g͙�t�
q��� �6�x��� ͐4˱���8q� ��<A�h�k��������LD�5(0�K�Y�A������Vs�SН�|��,}�H��}��X��2_�h����殒U��XH��{}C����`���1��C|�V���t>y?GW��=�&��37NS�����.f��i0xE�a�Vfԛ�s���Q�M�9:^f�|��$>��-�r�7ޢ}�KkT�'K���a��9�ӷ�<��T����S��d@����G�e	���l�@ �7�S����:�M��y��Zh�`�����c�.��B���o��IϽ�gj ��cS���B�o=��}%���ۻ~ߦ�(ܦ��� �2�@%�v�#��@�V�R!Q�N �i����&m��Ć@���_���:V����vdb`aB*�;IӤ�JZ���D>������}�>8�h�X���ͳ��	��e����CJ���7w��X|@���߅~��$Re���ȇH�������Ӻ9�.�ã�������9i�>v�����p��+��#�n�I�͚�S������Ӵ�����H/��z`�W�sd�A����gy������p<ZE����W���p�Rv��6�rV�p4��q�CHn(ԋ]�=����	<�)��0�E����5�i.T���N�� .���@��`Z����|"u���S���?��؛���b�����[�����$K�ov���さF���x�t��b̍ё�ʡJ���o�dᷠ^E�] �d~��&�^+�UVqRA��~����hs��a��u�j'�2�e�a�7��{u�4�`���
�B��5	��,S�<�-r �OGM/(�R�;v߫�8������x$�gL8!�%U��hV����.IX�{0��R)l���99<�َ��{��Ui*�*�*.m�a�"i��Ro8*�j+i��Ͳ��Kpڭ�Ў��(�6�V�����s
��deU7�0��A������tWGS���[oP�u,n���c�v��u��dk��eU�)ڶ�͙�je��S4E�J�U�K�\4d+猪��|���pw�����za�����?>n��L�>ϸ�T�U*�T����/���˶0�Y�I��j���2пl�|��q�`3í��n9OKB&N2v�=���I��ے�aY#��x[ⱉ$�\���t��~�������/�R�{?o/�
�ol~��p=��r�%�x�}�9��?�n������&�糑��tH�t�[]��N�I����I����I��uHQ���I����I����I����I����I����)�Aq�sP��_�s�l��`��:g�U=��!�?��3�?��3�?��3�?�@ �Ќ?��kV � 