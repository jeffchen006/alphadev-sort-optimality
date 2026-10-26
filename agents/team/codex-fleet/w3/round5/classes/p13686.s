# n=5 model=out iset=I1 prefix14_class=13686
mov S1, P0
cmp S1, P1
cmovg S1, P1
cmovle P0, P1
mov S2, P3
cmp S2, P2
cmovl P3, P2
cmovge S2, P2
cmp P0, P3
cmovge P2, P3
cmovge P3, P0
cmovg P0, P2
cmp S2, S1
mov S0, P0
