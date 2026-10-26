# n=5 model=out iset=I1 prefix14_class=11030
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
mov S1, P2
cmovle P1, S2
cmp P2, P3
cmovle P2, P3
mov S0, P0
cmovle P3, S1
cmp P2, P0
cmovg P0, P2
cmovl S0, P2
mov P0, P3
cmp P1, P0
