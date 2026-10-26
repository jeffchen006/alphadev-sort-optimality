# n=5 model=out iset=I1 prefix14_class=11435
mov S0, P0
mov S1, P1
cmp P1, P2
cmovle S1, P2
cmovg P1, P2
cmp P0, P3
cmovg P0, P3
cmovl S0, P3
mov S2, P0
cmp P1, S2
cmovge P0, P1
cmovle S2, P1
mov S2, P0
mov P1, S0
