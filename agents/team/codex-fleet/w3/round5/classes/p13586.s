# n=5 model=out iset=I1 prefix14_class=13586
cmp P1, P0
cmovg S1, P0
cmovle S1, P1
cmovge P0, P1
cmp P2, P3
cmovg S0, P2
cmovg P2, P3
cmovg P3, S0
cmp S1, P2
cmovge S0, S1
mov P1, P3
cmovge S1, P2
cmovge P2, S0
cmp P3, P0
