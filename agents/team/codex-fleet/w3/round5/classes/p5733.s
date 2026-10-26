# n=5 model=out iset=I1 prefix14_class=5733
cmp P1, P0
cmovge S0, P0
mov S1, P2
cmovle S0, P1
cmovge P0, P1
cmp P3, S1
cmovge P2, P3
cmovg P3, S1
mov P1, S0
cmp P1, P3
cmovg P1, P3
mov P1, P0
cmovle S0, P3
mov P3, S0
