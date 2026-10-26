# n=5 model=out iset=I1 prefix14_class=1043
mov S0, P0
cmp S0, P1
mov S1, P3
cmovle P0, P1
cmovle P1, S0
cmp S1, P2
cmovg S1, P2
cmovg P2, P3
cmp P0, P2
mov S2, P0
cmovl S2, P2
cmovge P0, P2
cmp S1, P1
cmovge S2, S1
