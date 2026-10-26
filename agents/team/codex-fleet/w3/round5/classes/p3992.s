# n=5 model=out iset=I1 prefix14_class=3992
mov S0, P0
cmp P0, P2
mov S2, P1
cmovg S0, P2
cmovle P0, P2
cmp S2, P3
cmovg S2, P3
mov P2, S2
cmovge P3, P1
cmp S2, S0
cmovl P2, S0
cmovg S2, S0
mov S2, P3
cmovge S0, P2
