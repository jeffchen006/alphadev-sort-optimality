# n=5 model=out iset=I1 prefix14_class=3570
mov S1, P3
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovl P2, P1
cmp P0, P3
cmovg P3, P0
cmovl S1, P0
cmovg P0, S1
cmp P2, S1
mov P1, P3
cmovle P0, P2
cmovg S1, P2
mov P0, S1
