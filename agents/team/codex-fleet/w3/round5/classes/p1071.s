# n=5 model=out iset=I1 prefix14_class=1071
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
cmovg S1, P0
cmovge P0, P1
cmovg P1, S1
cmp S0, S2
