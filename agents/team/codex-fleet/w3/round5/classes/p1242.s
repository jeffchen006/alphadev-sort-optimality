# n=5 model=out iset=I1 prefix14_class=1242
mov S1, P0
cmp P2, S1
cmovg S1, P2
cmovl P0, P2
mov S2, S1
mov P2, P3
cmp P1, P3
cmovge P3, P1
cmovle P2, P1
cmp S1, P3
cmovg S2, P3
mov P1, P2
cmovg P3, S1
cmp P1, P0
