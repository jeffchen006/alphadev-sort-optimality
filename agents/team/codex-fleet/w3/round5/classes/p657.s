# n=5 model=out iset=I1 prefix14_class=657
cmp P1, P2
mov S1, P2
mov S0, P3
cmovl P2, P1
cmovle P1, S1
cmp P3, P0
cmovl S0, P0
cmovge P3, P0
mov S1, P1
cmp P1, S0
cmovl P1, S0
cmovle S0, S1
cmp P3, P2
cmovle P0, P3
