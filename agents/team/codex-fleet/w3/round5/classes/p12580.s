# n=5 model=out iset=I1 prefix14_class=12580
cmp P1, P3
mov S0, P1
cmovge P1, P3
cmovle S0, P3
mov S1, P1
cmp P2, P0
cmovl P3, P0
cmovl P0, P2
cmovl P2, P3
cmp P0, S1
cmovl S1, P0
cmovle P0, P1
cmp P2, S0
mov S1, P2
