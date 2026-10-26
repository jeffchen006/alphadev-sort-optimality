# n=5 model=out iset=I1 prefix14_class=3903
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovge P0, S0
cmp P1, P3
cmovle S0, P1
cmovl P1, P3
cmovle P3, S0
cmp P2, P3
mov S2, P2
cmovle S2, P3
cmovle P3, P2
mov P3, S2
mov S1, P0
