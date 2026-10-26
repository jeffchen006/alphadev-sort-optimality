# n=5 model=out iset=I1 prefix14_class=6464
mov S1, P3
cmp P3, P0
mov S0, P2
cmovl P3, P0
cmovl P0, S1
cmp P1, P2
cmovle S0, P1
cmovge P2, P1
cmp P2, P3
mov S1, P2
cmovg S1, P3
cmovge P3, P2
cmp P0, S0
cmovle P2, S0
