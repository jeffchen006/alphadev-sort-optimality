# n=5 model=out iset=I1 prefix14_class=3616
cmp P1, P0
mov S0, P1
cmovl P1, P0
cmovle P0, S0
mov S0, P2
cmp P3, S0
cmovl P2, P3
mov S2, P2
cmovle P3, S0
cmp P0, P2
cmovl S2, P0
cmovl P0, P2
cmp P3, P1
cmovle S2, P1
