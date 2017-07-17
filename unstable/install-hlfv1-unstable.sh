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

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

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
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��lY �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�l4����O6�ř'�y��o�vd�'�%�U�f�E��Q�C�V}ls�eC��*�ޥ( |��v�o�/ݑUZg�܃��\����6J�Mhi�نVd�`)�j�c{U�;�����MҠ�W-C�A�!�J��RE*��J�L.�~�3 �8� ݄-�՜���PqP�-��j��tGk�KU��%�iT�����9(�č��4ي���	��=@ C��>ff�9ѯ���fw�.kǰV�c��x�#���+l��Te͞ӆڃ��
�3�kXMh!�@�����H���abږ��F"~�0��{�1M�qF`虢WS)fhQ:2�(R��k��ܞm���d��B�pC����5��1��6P���3��`N���^͐cFق���vj�|`�q�\zg�����-��#�ĜQ7�^MJ\�!W�CD���D���j�"�g�Va�怾�,�����au�V򕈧{��-]�F�hR���ԧ���o�CM�a�X1��m�E>nZ�1���x����� ��)�_��?g�([Mc�{T��ܷ2�����r�6�8�x���<����Ͼ�4T=Ґ�e��@@?�&��T-����I��V)��)���/i����4ѯșf�h�G��ֆ_̑,�x:?��s����6��e��7e�����s������o���H;���
�ư���n��� �h�����@�X��$�(L�	^�oj&�@����1 Y��y0���&q~��a�mWj���>���`��d���ڗL�c��$ɮ�1�)�����
�m�#1s�8/��h�׼�m�I�P�JGF�Fo3IW��]�����Q�h۪�c���^��w�t�U�fH����'�t��L
�?���Ep�0z\��l;�����h8m�Ij�}�zYl�{��,4�~Nb*gT�o�u�Q�_*ܲ�5-M���\`�q���8�1(�Ck����뀠�G=��-W'Nq�tdtUM#�ڂ=�Q"���޾�(`S�B�c�/^R)��{��IX�6���R[��&YdA~�h|x��ԑ"�J� �j�-�fgۡ���D�FtWӰ��k��Ij�Z*j��l\����zwr��2�Z=@*�n�
�bf<�Fp��W�6@T�x�<2f��D��?L��b½r��b�{d�2�;��|����B7p�Dfު�y$��F_�~�,��)2tmH$0�>:7}3���Ź�+l�z�WE���C
aڛ�9t:h�<�ݣ5(��P��U� �X6�g@S�O{�aN�= �i�!��cN��藔_�P���ͯ��/h���}Q�M>'8cg�t/�8��aA����5�T�cDoh^� �!<x�:~:�e�j:ܬ�_*�Y�1#=�����d�����|�0G�����X �,�ŧ��������v�x֙�� �d�iӦ6�,C�)l�f-��i�e���@֏a�t��wuBU�s��J��;����&�c���]��l?�@���$c9t��܌�,�Rgu�\ɕ��.���f��@ �\݆Ώ�H��n���A�8r	L��t(����:Q�x+��|2�w*��V�b�zV��R�z3�h�hg�h���˙.L��c��.����_�1�ćW�IT"�;��x>�὿��>���7��������Т���s��Y
X\�ɂ�N��?����]�_��κ=����"��Y����8����q�YV��8���끍��e����l9�\$�Q�����Bt#�뀇���]��g����&D�@(dZ��^��:�*���so�#�S����X=�3�ĄM��:`����݃����	�f������Â�\���pQA���S�%�7t��l@�2��i�����d�i�)�������@��J�uȗ=R��WI��9��v`�!DWs�<#��g,D&3��F�1js�2� L�	2EFM�6ЍP4(�(k�%S/T���0�}�����\�W�Sh��!��<�5F�U�� �_,���r�'n���//�w^(�̬�G7�k��U��#ǈ�C׏6pdOb5� �	p��h/�`�g��K���Q�C�;��b�l���M-]�vL�ڻo����^���S���7�_�G��GP�K5�э+`X^�˒�.H�^s�6��3�0������Ϟ��$`:�9o�C���%,/�w�,�(�#:c�,�������{���sE�y�����T��l2W$�Rd���J���_��Cs�r'p���N��������K84C���a;��F�!����[=���-����2�?�
�խw���P�1<�U��z'Ƣ��p����.f�(���(4�� ���2��ud4 ���n�9�#d�[���/(^�a�ϴ��l�?��	���8���u������/��s����x��^!��5QW�ޥax��&
̹�-H��T��멳�x&������K�=|� �o2���5�<�r��v �%�2���.�%r{�!�*���CI*���tY�T�Z����R�J����'��R�X�su�i�H_�"���r�џ`�|)���gy�.���R���i8��C#2�|x�;���b��3�'e.vu5�|e�����sՓ�I��\��Qo���l�KSX�e��W���J��5U���zw<��6f@�B
ض5M ��U�n4�w.�r����3o�v�%~j�}@X��wװ���>6�������Z�����������N׼�.\��%��9��� l��fv�n5S�6Y���6�K�i|���b�o�X,z�b���|�w�y������Z2�����{翉�o�?����\
���ð���G���������]�?HC~x�����Ea��ȷ������WRϖt��������U5
6b'n	@���SW`����-p�Ss�>,���s)�B��������<������|����`/�(���7`-*�ȫ�+P�T¿(}�VW�4�e�4����}.�X$���_N����~���$�T��v��1�pty��6�Ηa�����P����fr��ǹ������?���Fx��d��a�a�y��Az�&~C�u)J1�h����ЃG1x;ȕ�|�^�0~xf�[0�S�q�?���⿺2���t��|d��*W���GT����l��(�q�9o�L�R�	v�.�����a��3>$Ï�x�p��	�������H�ݡ����l�ݜ�]�<��J�SOa�bQ��~�������� �?_Sgԇo���������#����_`��(<�%vZ
��|Bn5Z���H�Z��sq�,�c|�����'�D�m�w��#[����_Q�o������h����d�l=���Gy�z��s�J�mX�����u�_���"v�����u9YM���&*����@����������5��_�Fy<�T1�֟����'�2�7L�����#�S��Ͱ��w�6V��Qf���w���s|˴�@�s�����_|��X��[����;�2��8��GZn���*{�(�(_�����ÙN�w?Ҷ��޸��8C�²�,7�5Z�߉2;��l)|cGI�\FY!�Ӕ��"�;q9�`㲜�y�!�	u\�GZ�Hն������"HI�j.�K�U�����\*{�J�J�-rI��+�E��׋���H2;4��UC�jG�T�$w`��.�	��K)�j�Y��I�N!U�.�K��l먪j�[�4�Z�}����E�\�yyJ5]Gyj2�^Wz���.O���lU|�aU)��^J���N��6i�V���\�E��)T%��y��{s1��X�*��y�+TsL���q�9IcFi����d�pdRG'���QV���.�j�]*Y88�2�||�Wz�yR���#����{��eܜt:<9����ƥ�*$�!�G�eG>D4z�"h0�q�셖���j��d��M�V
|BlK�T��=��E&'&����E��v/*�B����ŷ�������h���7�}=�=�ǵr�u"��YQU�?�����N��م�a9v�K�l{pp^�&��Gs��m�R228�s��N�<���BRl�H�(R6�U378�Rb.ٳNe7��%�u���z��=$9�T��T&VP�7�>�r� 㞡L�L[,H�T�(��G��zJj�ڨ�@~G�LǉHG?}O�Xяk�z��jFڹvE8���a���)K�A!w+�������̨������ZY�{�����9b@_]]�#��/yCo�U���Z����Sֻjl0,cbO@��虀���ùoQ�o���Ww���N���X��/��G���DYV؜�\��r��p ��ԧT!��Gk�x���2�PGGm����䁡Fj�{J���:Sa��b�X��Z&�����ιdr�D�l�S�Q�X6��eFN�_]��^J3^5`�)�׻��QY

��>�U۩α^3�Z� '+b$]s���~��=�,t�B�)5^�f;��G���c��g�a���>���6>u�7���X��9�?�9�����d>�
.���@���x4v���#%}�%9>��L�&W3o
�m7b��M۔{ѧ�Qʜf
]	*n���[ϔ����仗���t�p��mup�$�M�]��i���\��)�ԣ���;���tX�R�᡼�5 �?�����&�k-��sh���\���e�a j(�4�!�f�z�c1�oCy�}���m��������C���T]�"�JVۦA�aK�U1e�pT�����!m����m|o��D�|�LR�|z�a+���<B�!P�{p7� i�'��.�W��n�HWL��Y�@�g<��5c@B���ѠA���G���2��"����������<���\<���YxD�c�o�}T�%�_s�tx�c���_�q�-��u:䥫�K�P��������D$�B82�����Z~}�B�Z��� ��q����&ƕ#�'�(��D~��°
�D��������>)����?��9����v��n�����zR��.���"N\�pB $pA �vBHh9�u\����m���ͼyp��̳���������U���6��h�>�&���,�sG.�l�c�H0��*%�zYM1!o��U��mj�J�Բ�
]v����#��u�|����R�c�G?p���	F�{�/�� �,��1r���
6@�����r��.4�%h��g���x3���zV��c�{���N�h��$v�g��=�����������d��M,���|(�Ч����1ĕAm�Y�T�p�*��99Q�1h3E_���X����LӆN��r�\��u��qHM!�D�z�k�Eᣓe2Wc��9 A��U������O�Ͼ��ΰW����TchLה�5 �� �&�Qc䲾p�|8��%�a�_m�8@�o�{N�2<Yc:��RްkS��+�D�tn
D5Ğ�|�3=��� ���7��deN>�G�<qٹ��U�z��L�5�v-�?R��^?9XS��5۷�xK�c�`Х�é5E�F��OM�E�Vx��VHɰ�.?פ;7��ҁ�N�vZ�����ᲡE�LE e�E�ښ�W�k�f"��4r�5G:�v����h7�!��V*�[_���9�ʣnz�R����ԩi��+qm�"�J�n=3�S荁,c;Ecl�F��t�$���_UAmH�u'b]=���Hbc���R_���J>��.9=�ۧ�J��_���_����tN�?�����Ol���O��B?��ߦ�ߤ��;�����[;���o���L
M��x����QI��Ⲓ�%#�x\�Œ�L$��b2��3 $%�v"��I�!���������Ї?���{�U�����>{�3c��~�?~0}磯��oE��GB�	����+d���B��`�6�����{�����> ���~� �/B��`�����j�1F �XƔ���E��O����^���yִ�>bT��?8�Tk5�>c�`E�a�᫈ ��#0]'s_�mVq]�1�\�QnJl'������tT8kυ�ZB8� ��p�j~!�yvIZ[��cQ�6�4���1�n�ǝaf!��Po�9?+p6%�&����ؗ��q7Z�	����1�7g`�����8�nQ��oN�ь%�m;�b����v#���k�Ġ�J�aӃ���/��f(����R��:	���c�ZZ�>�dǺ�+��k�za �e.W�5�s{����$$L�A�'�"6��Y�T�Z!�а���P��4V���v�`r�m�6&�M#�ْc�Y-��jM�K?O��Z�Z�T������v߈'g5��X�ڣA�?>�o��:dY�y5������Ŵ�
1Ϥ��r_+5��}uϚr�m/�JS5��O�n3��V�i���(M��RR�̭��+"G�zB��l�W���e�w�զ��/���/���/��b/��B/��"/��/���.���.���.���.�m��+�y�x�Q������D���k��"���nv"R�s����r'�׳��E��?q;�8Zr~�$�﹋�!P�Ph����������,�@���w"R�v����I���&��H=�*Ncs&Z��P嘥�:-��=[�odZ��@��N��vND���� ީۺ���L��1��KԒ׻��?/�~R���g�L<�L�+ϖ'����@�-m���������K�O�.��
EL�\&�P�xBM��i�vn�n�m��Y�4�dy����g�^.�
��k�f�Y�t��鱠7����Y:9�в]wo�^d��ۡ_�y=�(�z����k�o��\n�����a�����f��c_��F�,����a�е�"�i蝝o�v<����.]�}ev9]�`�[~�B�X�7Co�^�+pY�Џ����o<
���D�=W����Gn��B�� ��s��gך���2�|>o�g�Ԙ*�Z��T�$)��|>_��ϱt������w�cXX�N �ǖ��M�,@��Y.�6Qs�r��ٜ�.�ڴ�'��,p�`�B��%�"�v]g�3+�!0�� ���f5
5fI�
�i2�,�㪒;��d5ޚə!U�#��.�k�H����I:;���9��ּ��t��<抪Ə�������8V&�}<vˠ�Y$v�ͨm}�Y���Fƴ�x,ȬZӘ,$n9�:�jt�����R����l;�0�-�o����(�r�f��h�DY�'y����𘊈�I*>8��B�$�p��v��A�*H}1kl�
���ҏ��~g6*���b<����,�TpU<��k�*Mʒ(���0�7�5aZ*q�R�T������t������� 9���� ����$|�b�'�����(�q�2;X�u��N���g\�Sw���;�c�3��V����ҧ���\8�B.���l�Z+W�f*Ы�j��7�i����F��R.��-��+�en��	�^R��]v2�\���*=JkٳA�S����y�,p���m;�2��Y���#GYΘl��Zm�B�Pk�8��
�����V���鄮JD��9�f�EႫn@��ߧ0=Ꞥ�J�s���ؔ�\���	&���!8�\a^��PaTV���|o�-h<��{��¶�F�O�*����..k�^(&��ku�,"G�X9�<�ƣ-5�S�� &\�Jl�}��İ��H�9/~ԉ�.�y;�K0�3!Vq�����L�(��
��^�P�Q��<�e��fRoT9��8�[C.3����˚t�M�:��F��8��Ng�r8�X%��ԛM㸟����t��e�<�m
�y�-%�,����>S;-m�Pusd���,\�%�ϔ��N��q������KZ#�Pj���I�)���[tG�ON2�*=q=�P(��g����n�ۑ)J��$�Vm�pa6�/�N���4*�^�R&?,��B�ǡ�`��K��݂����晢~�y�<~���n_t�0
�z�x#jzt��L<pcպbZ�yq��	~���ૌ̩).�J���[ě��>��󸌆�TBCo����ԇ_~I�m�[I���AAO8�6��x��p�	��3�=�29�&;V\�ϗ�'��`���J���C��������E̛p34�[���f���=��'�w;���b��J�v�]�S�m:>��ҹ�K��z����ן[n��ቬ�͠��s���H2v���x4����W��/rE��.��n�t=%Y��S�kH7�;�0$�T��2ه��=<L2]t��Y��	*>T�9���� x���}�����<$؄5�5�y�5���47}��>���!����uP�A%�.]�Kb9~�Z��^��g����"�kJ�Ku��>Kǿn���r}��P[Dxzk����נn8����z�c\"A@���=t�=!� �anp�O���!z&1��T�>����=\ 2�3�m`D�p����e�&&q7��$o�fߘ�29R��B�B�.����_�:򒦖g0���
���U,a@�}p�lQ��Iw���j� W��p��x�m�C�X���*���cp�"B?�~U.��g��B75`�H��X�z��Y@� ���&��&纐1��n���M�����3sX�k��_��`B���+�W�N�!�r�ݓ�VF �Չ6�jc��urtn�$V��R�/�ٗ[w$~�@\#���)�M���E�޼yC�c�Q�oLж��q��Z/��v=l*>��~�@u~�	o ����zV�m�����\��Bt��T��F]k�\D늗2���Hx��ŷ�H9�����A�VD. �7N�@HJt&��y.+��jе��ř��"|l6p5�����N6c���[ZwK�D�1�upݏ�q"%ߐ���un2�V�WA�DW��o�F{��tg3�� ��Т����@o ة[�S"q������p/�u{�����V������i�%�gx�m�B)���Op�同����*	��F������V�(��a��C w��9��Q����A��̵�t�� �v�L��)?�=6n`�r�@ȑ`i��<���,,(dGV^��r%D�N�7lo4���+�Y򪊫��L�[,�-8�&&X�*���Ɩ���/�~$�%Ào������t̸Wj�#,�-#��@�J��d��N��<�Ʈ����+�#�'�����1@�VX�L<�1)9� ��
(�{��`T���!�C�|�����뱉Wֆ���)t��u��d�+Kܜ�F^�ѩ��є�	��!�����.�`�M����F�e��k7�#�n7�@���W ��ո����dی�:;��v��Z�y����w�\[�5���hju�[<�������W�A=��������u��-wn8�_�vx���u`Ƴ�h���:�=�ҧ�j�ga�ꆷ�s喌�~��ѷ2Yl�-��U�Ы�_�A�i�:����ك�rMAG\���Ѩz�DR� %R��1%��%��nW�Qr�G�b��LT�zR/��xZ�$85�%C~/��}]��ܳ����|`X�'�v�O7�ㄼ�S�r���/�q+�t�/0��@Y�K*�dH���#)�TT�w#  H&�%I'�JH2�CĠ$�%�R(�
�Tr. :��6�T�Kc���A��'�]>�ik�.po1;u6�mŐp��`k�-�ר���/��J���pX�2W�K��J��s�g�"M�����ȕi��s�Ƴ��"�R�|C��B�}���!ݮ_���%[֮hT�.	�*�>,�]G�P��9�V���
b�<>����h}&l���j����9�U��O%<�.vֺ�zGTl�t4itf�[F�3�/�SO\kd/�p�]�2� .��)!X��%���������;@/��J�C�<ϗ�U��o�t�<[��r�®(�`9��_'=N�2[��e��t����0�j��Ix2��Ձ�8'*��+�����]"N���Y7��=�Y�����s|��̉�J�H��{���ip��z�k��I^$���*-.*���-�N��<��i�s���H3t�{�E������J3[`��e�ʚ�֚��~�}��A�p���O @!Ġ�S��$��_��;�ډ{=��!�mi�ս�W?~���{�@O�T9Id��ź��Nzy��޵m�?#��?x����2r�:w�GO�����������bﻦg��o�����u~��^�L�������=���2J��z6x7����o�=��������o�N뽳���]x��4�_��<���y��T^ėtѿ���������n�%�{���(���A�0�޹����x����I�$��}�o�-���<�X�sԭ�7	��(���6OC�-cC�b����<��8�?M����:���お�����@ї��������h����	�~�g�~����H���ܝ�_��� ���#�?G���ɑ Fԙ;X���Åq䇒 Ra̋�8bB��@`�8 ��bi?�7����s����[�����|L�/���G��d�M���[��6D��m�5��(#)�ZL{���Co��O�?�J�,o�QG҅0�k�=�t��nfs��:�v�/��)5�*c������֩�ۤ�َ�5�ǐR����:^��ڏg�Y�������������0���	�����?)@�p�����g��Q ���0������_<����8A �G����R�]�%�� ��/��)�6��	0��k'��D���_8�s�-����(��_}�U�耊�V�����S���0��t�?���]�B�Qw�?��	0���a���s�?,����� �G���C �?G��R��(�R�o_��x��S���(��l^�j1�N�\���<�������{i�$���yy�0k�{?/����z?��0�U#����>��>��MS�P���,-�F��,��f\n�S�㲼���uʬ��j�y:�3�Ҫ��N�4��R�����q����7rc��ϧ�O�W�>�~6�����L�u卿Y^���+����`ul���x�a������ܝf���3#�8�N�I�工dͪij�S��KT�:��.�����f����:໭C6�6�u��	{d���)�mI,����ߵAR � ��ϭ���8�/x�?�D����'
�#�?���?��S����G��C�_:I���(@������po|���?
`�����������Ë���s�|�����χ�<��FÞOڼ��������w��?���a}��{GS�qXO�t��n�ܵP҇}0�y�uԹ�l���t�C�>W�d��󆷖��(�l�P�$�ԓ���M�Ϗ��P�k2t��oY��^�z���>�M9����CO�j�r�x駊j��J���x:��1�s����vB�N4�`$����g<���U��g�P�*�X�AVIG�ȭ����Q*����+�zR�d��"�I=z��꙽�5����`���;�����Y|L��6�� @������<���_p��8�4
(!qT�<q"�"Gr��d�b �������L�Lȇ#1�0#�ׁ������~��zjz��a����J��t����I:��Tb�ymZ1�$������(F�r�v��@�z�'����w����q���������bɨA��$M􉦹�6�>ƫ(X�.�f�e�`�Q��_���,���N}�?�������?|�?�0���	��C�W~g���l��k�����C�Έ���Κ[=\N=orN��vO��d���S�vy"��1���ڪW}�T�ܙ��z�Xr���$e��Js{N�8ϕ�hW�:�E��i��ۺL6�r7�8��^<����?��	����C������/����/����+6��`���F��%!�?xI�y���K�����ͪ��ǻ�@h4J����4-���$GO���e'%�jk�� ���w�  �ճwg ��jX��é|W��! /� ���h�v܆\.5��8���y��.U�J����r�8Z���B��X�^Shd=*	�U�m�r�;�7{;��l��&^��g��w���+\|���W�� �݊���9�*�^Q�ⓐ��Т}�VN�vlU�=ED�m�rZ�!�֠�8��b�Fj��C�m�M��V�������UB<��v�@(���z�A6��u�,F��)TJ�a��L&Ñf4�Ċm6=v�N[My�Lc�;�V��2�<�+��������XT��u��Hƻ� �G�w��>~�}���(����?����y��@��&��@�? ���������9�����������������  ���<�A@�")D~D�1����>ϳR,�"/ƌD�i>Cӑ(ŬS>�����a�!��S��	p������k���X��p1��4�M�דՃf������o�������_���u����sb��jiT=r����R�!�Fi�'�|;h��>�[���Ǔ���O�]�t]Zj����z��E2�
���8��{g�������b�P���(�����!��X�?����?D@��~����;� ��/��i�&�������ˏ���`L������ ��/��_�C�k���k-{V����q5&+}6�o��S!�ߚ�?��5&�S�}y�xO���(��i�w���~'���|��Z�k��;�qPl�:;8]��j�k06�S.�1��t�Jmٜ�{¼㎆~CnT�șL8S�o�k��FjF������i��4M����\�������D{E9���z�NPE"���,o,6����jmI����X���Ve'����a�lڰyBՓM�Ƭ�$�/��K�$h;˾�����#q��ZX�c�������)	;���Z�''G���}d��ld�A�����-h��w��n������_Z��Bp܀C�������	��꿡��������l�B
 K@��������9�_�, .�"����Ks�� ����/����o���w��I�(����.��Ң�'�>P��[��$���i�����@�����a[(������?��.
�?�C����������	0�0�(������?wg�� ^����������$ �� ��?���]�B�Q7�_��@�t���?��Â�����D����-� ����`��	���������_A��!
���[�a��p�_��0�@,��;��? �?���?��C������H���K'	����?��Â�����#V���ȁC�������������]�B�Qw��0����f�m����s�?��yv/��t���)�,2�`D��Ȑ�H��Q�b(�43ǋ�O�g�}J|)�ߗ|��ӏ���^���OA�_�����w��������j�q�?�@�*���܀m'$i�ͦ�XM��d��ג{�Cb�ڟ�����N�^һqG�TY�l�jj�Vgm��S�W�ҩ�.����	��f���pG�2�9�W���D���j����C����cS�u�x+�xe�_C��/U��8����Y
���9��
������?�����a`������8����2&w(e�n^)-k"+5G�Z���S�z���}Ȏ�Z_���_7�e�Ι[�2�*u��vlD��N�G�1IX��o$�:T�M��`۩�����*o�Sk�z]�s�i;m����:gA��Z������/"`����?��o��p������ �_���_������@,���a������xI�����/�O��z��W�����t/*�}���_%����A�]���x�W����$^��Ǭ��v��咶�I�uj�u��5�%"-��'F-���S�f���N��a'iL��|:e�fĤ�u�4~͞�N��[�Y]�ĭ��'�W���w]:�R�o�%7��U����u�T6��Z�/��IҎ�꾧h�H��m=VN��E����Z��Ho�B��mը	���H�9>�T0�D���/�{���<x#g��J���k���"�ZJMePQ2�g�H��U���R��0��h�愍����W�����F�����3^y�K���W�'���#�����W����?�8�{�����ࣟ����xa����ϒ	��8�?MR��,�?
���_O�����������ߙ�y����K�?���rt���aZ���^&�Τ$��}Ƽ9���w�T4�y��P�燥����q�ο��tN�u�Yͯ)?�s?�R~�ל�����o�=O]���<�.;���%syq-!��-�w宒���VC��u5%��9�%c�����K)?w�:����B��z���u5�G}Z�{�c$�~*uה?�%gh�9%kR?w�Uo\e�'q���i�]Qb>�ʭ�#Z�ʻf����q��������ϲ&���~�����Kv�l��{"�{����6��SR����1�I������͕�1}�-1�Y��}�eN���)�<Q�qs�
��u�;��z}��ʃ�th����i.�VN)1e�}%wCr�/��T�Cf�HO/k������/9-m���޼����M���"�'���H�XڗFLH��Y>�F$K�4?��H#�>�B2$ʏɐ������C�[��P�����_㓑\�ў�$t/�{A{�Owq��m�E��S����[��Z!�"W.j��_��~�/��7��p��?��>8�?J`n���� ���?��b�_�����?$x)��<]��������V7�(m��t�3�Qx���h�a^y,��s���$؈���f_������.�?������O���S��)�G�.�g3�̩�ʉ�Ԅ���w�͊b[�;�®W��u��2Ƞ]���ёȤ�(jE����5�fjUfe�*�+"#��GYg�s�^��i�\�{���#5�GN�e��;]��y��Xo�4m�fyW3�З�� ٰjN�3WT,G��I:�|��u��3�j��u8�vlJe~Rf�H��;V����\n�)+��g����c��qZ�f�����Npld�r=�&!��Q���8֑frֶ���Xد�8js�a���8x���RHT�ۛ!�d�^���~WA�����7d��S*���AW�8V1�����t�b��4J�ժZŒ=z��U�"T��-x�V���7D�����<����{{|��?�A���m�R��9ք��i��� �z����y�Ἄ���lIU����o�����0��8��e�"�D���?�_���W��_X᱐ ��ϛ���+?d���*���?���n���?|i��O���?��
*�c��޷ZB����=����ø��W�����>�gvr]���v쫉�a��#g��Pi���J8u��Sg�M�ɗm����Jh]g��o����\!�KW����嵅��֦�}_�:/���Y��W�(t�b/:X���s)�;�E��yC��B������,��$�ZF��S����=֫:�j�.:,=��:��ޱ�2�6_�.�?�m����y���cy�ZS�ئ�V�Gʖ�8���/3S{״x��[��w���%�}c�5LN8��6�V�M}V��bb(��z4^��2d
�UL9v�ݢ-4����uX�>"�RC2�|Ñ�5u�G°f�k�1b���mU9���E�����!�'d���*�E����������S~Ȓ�!�x(D����P��	 ��?!��?a���[���5�0PH@���������!c�#�������[���3������������{�����W�w	�=d������� ��������?3B6���=BA ���?�������L����y�; ��?�'��X�)#�����?����s����/8�(��/DNȊ����C��?2�?���?<.
���;�P��	��P�? �l�W����?@�GF(�CEH~(D�����?�?d� �� �������_����c�B�?��熂�?�B�B��7�	���& �� ���w������d�<�_�X���3 �l�W�'��?@�W&(�C�^(D������!������?9!O��6Na������������&���2B!�_�	70��,)U��C/5�F�n�K�R����NҺij55�C�VØ
�����~�?<����6����l�*���I�����K��6ז��N��Z���/�c��IX��c��E�gנ��
V�N#~�b�V���$��Z'��O��uۼ=`���Q�3��8)�q�(s�q5D�z��d�txc������7�֞�{�(D4�q�«�<�V�7Or�;�����8㽛�ʻ��"�����������E��!��E����y�����00�Vx\��!���3��T�MH{q�#��Ð�i��nӸcY�y�g����[��5�k
�uw��֮���]��\
G�HB�䰩T��n�t�5��RQ9�Z�"i�ܭ���.��Xh��sy�C���(F�_��ߜ�g���Oz�#6��������� �_P��_P��?��r��#
��(�F�Up�Y�������Q�u;V�~hmՁY�8�������뿏�X�Dn!ᾶ�>Ӂ����6��h��,���}
è�p��vc����d�ռY��r�qZ���cB�\"��֯%�l+��^SĮ�Q�~E���z5l�%4WZ�۵Y��.���W)"�:�|�rñp����������2�x�q�q#����]��8}rys[P�c}��{-��W�ON4��:���s����%]l��R�Z`G׭�ٸu��y5xD��r����w���D�R��G��������Qe�^�F�N��S^x���� H�((����4����T����?����N���2����=��O�����y�?��������@������ ������S��?� w��x�m� ��ϝ��;����	�����=���?����?�Y ���������_�� w�+@�
��[���a���P���sA!�������L����sZ��~�����;
��MO��襩����l�?�X����s�GZX�|[�����#�0��~���W������Z�۽��^�7�����W�h��sg\l0{���r��⪏��9=4�5�t]L�捲�b��Ӵu��]��C_���dê9=�\Q��W&i�/�u�ײ_�Nݯ�	g��X�rر)��I�a"U��X�:��sq����<_��&r��uf�iݛI>�Ǯ;���1c�����;�4���q�#��m���_7q��<�&7Fyq�ZSy���.�7C48Ɍ�~��B�?�����W�������[���a�?7���_�(@�(D������L �_���_���o�O��ON�]�}\<�xH@������Oa��9�@�� xk"��������^O��_�?*��ٰ#v�xRu�t�Q{6����E���Ǳd]�':�ltwr��)�Q ��Ǉ��!܉��) {^S%�fU��:J3[EY��-���4�24B��ö��O�<����F	]<6*t���C}U��ք�� $-�+5 HZ�G5 ����lM���]|�������!ў�,w�$$ʶ�^�մ>/sTXs;�p�4"w(��ʽ���qHM�5s��;�f{?|��(������_� w��a�[�1��c�"����X�����F2�ZaL�Vu�VU�e���4��p�0	��
�MLe0ӤtCch�Ve�%M�����#��o�O����s���`��U��|�3gd"a��Q��d0g�AW1ע1�j������i;#���*�~�
Alu�3��f�HkJ�mߪ�j�pX*�����y�S"�(	�崁.�`�K'𩇭�����Z������k��.�w<8���C��
�����r���E �00�xH��!���3�����^�ZOR8t�!utM����V$v����؉��k�G���v���u���{��c�՜R����a�	�5��<u���
|ň�������f�'7ބ����_�b��7�_T����{����*, �#
���_�꿠�꿠��@��9�0A�QT�_N��������?꿖����;�L�(c�i4�a�MJ��^��� |O��m5 �u!��5 ��Ս@G;U�y��ˊ���i�W5}m�Ƥ���TC�hE_-�Lt���,�n���kc�L�������rg��6+�[�?�yH��8�����=߫܌��7�8%�?���^/��+0p�H���M�Z��h�)UA�5�u�m%
g,MI�:�ňry�㓫�ʣ�G�^̔��P�
����o�Q/"�rq��V��at|I癉t�loE+Ę=m�ũc��m,[�C���<��֡^�Z6}���9![k6V9���2�a;��������V�;��St��>���������	��P��Y�ҝ[�WJ���w/��/O�v�O'�M��o��$��@�����ǎ��ܛ֑�q�1=�;?ؚ��(�/���E*H�ǄNXz��G�>�6[}]z���zg]�?i�?>#o��gl���#�������ꗍ�/�t}-�K��/[����1���O��H|����3�0��S���?A��?���=����x���6���$����J��Q��m��8^TR7��qUo>!�����=R�j��6J�>��ȥz�NH]�����*��R�_��S]#y�+��������~*��O�������UrV��-�&'����1�,RH��ˆ�;�� ��c�N��޷�w��-���դm�mPj�|#�K�J�G�mK�OHr���jr��yi���	y{�s<��I(*�Ў�.9a�7J���p�F�Gr[�G���F�O���f����-���cCa���7��I^��ڻ�sr�^�#������ԟ7_�/�S�ۖ�����`�����67jD:jl<�����:�Xe�x�wII�����O��]���}O����툲��Q�\DZ��S⻬?��'���U�J/������te�/��	}zz�~    ���>{�m � 