# n=5 model=out iset=I1 prefix14_class=8568
mov S1, P1
cmp P2, P1
cmovg P1, P2
cmovle S1, P2
cmp P0, P3
cmovge S0, P3
cmovge P3, P0
cmovge P0, S0
mov P2, P1
cmp P3, P1
cmovge P2, P3
cmovg P3, P1
cmp S1, P0
cmovle S0, S1
