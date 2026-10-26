# n=5 model=out iset=I1 prefix14_class=13915
cmp P2, P1
mov S2, P2
cmovle P2, P1
cmovle P1, S2
mov S2, P0
cmp S2, P3
cmovl P0, P3
cmovg S2, P3
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp S2, P1
cmovle P2, S2
