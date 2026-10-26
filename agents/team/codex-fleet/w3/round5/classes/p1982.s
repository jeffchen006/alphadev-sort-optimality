# n=5 model=out iset=I1 prefix14_class=1982
mov S1, P3
cmp P2, P0
mov S0, P2
cmovg P2, P0
cmovle S0, P0
cmp P1, P3
cmovge P3, P1
cmovle S1, P1
cmovle P1, P3
cmp P1, S0
cmovl P3, S0
cmovle S0, P1
cmp P2, S1
cmovl P0, P2
