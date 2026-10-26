# n=5 model=out iset=I1 prefix14_class=5495
cmp P1, P3
mov S0, P1
mov S1, P2
cmovle S0, P3
cmovle P3, P1
cmp P2, P0
cmovle P2, P0
cmovg S1, P0
mov P0, P3
cmp P0, S1
cmovle P0, S1
cmovl S1, P3
cmp P2, S0
cmovg P3, S0
