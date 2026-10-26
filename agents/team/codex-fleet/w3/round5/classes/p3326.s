# n=5 model=out iset=I1 prefix14_class=3326
mov S0, P2
cmp P3, P2
cmovle S0, P3
cmovge P2, P3
mov S2, P1
cmp P1, P0
cmovge P1, P0
cmovg P0, S2
mov P3, P1
mov S1, P2
cmp P3, S0
cmovge P3, S0
cmovl P1, S0
mov S0, P1
