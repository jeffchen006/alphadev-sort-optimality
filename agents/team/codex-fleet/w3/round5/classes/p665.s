# n=5 model=out iset=I1 prefix14_class=665
mov S1, P2
cmp P3, S1
cmovle P2, P3
mov S2, P0
cmovle P3, S1
cmp P0, P1
cmovg P0, P1
mov S1, P3
cmovl S2, P1
cmp P3, S2
cmovle S1, S2
cmovle S2, P3
mov S1, P2
cmp P2, P0
