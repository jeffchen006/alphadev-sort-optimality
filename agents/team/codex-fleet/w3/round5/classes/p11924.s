# n=5 model=out iset=I1 prefix14_class=11924
mov S2, P1
cmp P3, S2
cmovle P1, P3
cmovg S2, P3
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovg S1, P0
cmp S2, P2
cmovge P3, P2
cmovg P2, S2
cmovg S2, P3
cmp S1, P1
cmovl P3, S1
