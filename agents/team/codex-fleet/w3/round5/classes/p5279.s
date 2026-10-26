# n=5 model=out iset=I1 prefix14_class=5279
mov S0, P2
cmp P2, P1
cmovg P2, P1
cmovle S0, P1
cmp P3, P0
mov P1, P3
cmovl P1, P0
cmovle P0, P3
cmp P2, P0
mov P3, P0
cmovle P0, P2
cmovle P2, P3
cmp S0, P1
cmovle S2, P1
