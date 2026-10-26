# n=5 model=out iset=I1 prefix14_class=4497
mov S2, P2
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
mov S1, P3
cmp S1, P1
cmovle P3, P1
cmovge S1, P1
mov P1, S2
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmp P0, S1
cmovl P3, S1
