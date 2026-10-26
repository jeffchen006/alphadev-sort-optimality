# n=5 model=out iset=I1 prefix14_class=2146
cmp P1, P2
cmovle S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P3, P0
mov S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P1, P3
cmovge P2, P3
cmovle P2, P1
cmovge P3, P1
cmp S1, P0
cmovle P1, S1
