# n=5 model=out iset=I1 prefix14_class=2245
mov S1, P3
mov S0, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, S0
cmp P1, P3
cmovg P3, P1
mov S0, P3
cmovge P1, S1
cmp P3, P2
cmovl P3, P2
cmovle P2, S0
cmp P1, P0
cmovle S0, P1
