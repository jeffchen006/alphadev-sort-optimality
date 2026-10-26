# n=5 model=out iset=I1 prefix14_class=12945
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmovg P3, S2
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovl S1, P2
cmp P3, S1
cmovle S2, P3
cmovle P3, S1
mov P2, P1
cmovl S1, S2
cmp P0, P2
