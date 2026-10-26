# n=5 model=out iset=I1 prefix14_class=4957
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovg P3, P2
mov S1, P0
cmovge P2, S2
cmp S1, P1
cmovl P0, P1
cmovle P1, S1
cmp P3, P1
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P0, S2
