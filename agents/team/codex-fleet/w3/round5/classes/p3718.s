# n=5 model=out iset=I1 prefix14_class=3718
mov S0, P1
cmp P2, P0
cmovl S1, P2
cmovle P2, P0
cmovl P0, S1
cmp P1, P3
cmovle S0, P3
cmovle P3, P1
cmp P0, P3
cmovge P1, P0
cmovl P1, P3
cmovle P3, P0
cmp S0, P2
cmovg P3, P2
