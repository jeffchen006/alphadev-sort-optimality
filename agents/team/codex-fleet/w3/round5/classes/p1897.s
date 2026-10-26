# n=5 model=out iset=I1 prefix14_class=1897
mov S1, P3
mov S0, P0
cmp P1, P0
cmovle P0, P1
cmovle P1, S0
cmp P2, P3
cmovge P3, P2
cmovle S1, P2
mov S0, P1
cmp P3, S0
cmovle S0, P3
cmovl P3, P1
mov S2, S0
mov P3, P0
