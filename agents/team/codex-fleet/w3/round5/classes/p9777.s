# n=5 model=out iset=I1 prefix14_class=9777
cmp P2, P0
mov S0, P2
cmovg S0, P0
cmovl P2, P0
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P3, P2
mov P0, P2
cmovge P0, P3
cmovge P3, P2
cmp P1, S0
cmovle P2, P3
