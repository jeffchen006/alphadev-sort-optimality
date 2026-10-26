# n=5 model=out iset=I1 prefix14_class=1070
mov S0, P3
mov S2, P1
cmp S2, P2
cmovle P1, P2
cmovl P2, S2
cmp S0, P0
cmovg S0, P0
cmovg P0, P3
mov S2, P2
cmp P0, P1
cmovg P3, P0
cmovge P0, P1
cmovg P1, P3
cmp S0, S2
