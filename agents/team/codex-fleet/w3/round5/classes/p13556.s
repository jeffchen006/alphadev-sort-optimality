# n=5 model=out iset=I1 prefix14_class=13556
cmp P2, P0
cmovle S0, P2
cmovg S0, P0
cmovl P2, P0
cmp P1, P3
cmovle P0, P3
cmovle P3, P1
cmovle P1, P0
cmp S0, P3
mov S1, P3
cmovl S1, S0
cmovl S0, P3
cmp P1, P2
cmovg P3, P2
