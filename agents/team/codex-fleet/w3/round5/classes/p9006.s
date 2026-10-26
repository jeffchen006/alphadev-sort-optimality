# n=5 model=out iset=I1 prefix14_class=9006
mov S2, P2
cmp P0, S2
cmovg S2, P0
mov S1, P1
cmovge P0, P2
cmp P3, S1
cmovle P1, P3
cmovl P3, S1
cmp S2, P3
cmovge S1, P3
cmovg P3, S2
mov S0, P1
cmovge S2, S1
mov P3, S2
