# n=5 model=out iset=I1 prefix14_class=8168
mov S2, P3
cmp P3, P2
cmovl S2, P2
cmovle P2, P3
cmp P0, P1
cmovg P3, P0
cmovg P0, P1
cmovg P1, P3
cmp P2, P0
mov S1, P2
cmovg S1, P0
cmovle P2, P0
mov S1, P1
cmp P1, S2
