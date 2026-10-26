# n=5 model=out iset=I1 prefix14_class=660
mov S1, P2
cmp P1, P2
cmovl P2, P1
mov S0, P3
cmovle P1, S1
cmp P3, P0
cmovle S0, P0
cmovge P3, P0
mov S1, P1
cmp P1, S0
cmovl S1, S0
cmovle S0, P1
cmp P3, P2
mov S1, P3
